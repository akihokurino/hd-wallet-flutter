import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hd_wallet_flutter/infra/account_store.dart';
import 'package:hd_wallet_flutter/infra/mnemonic_store.dart';
import 'package:hd_wallet_flutter/model/account.dart';
import 'package:hd_wallet_flutter/model/error.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';

part 'wallet_provider.freezed.dart';

final _networkUrl = dotenv.env["NETWORK_URL"]!;
final _chainId = dotenv.env["CHAIN_ID"]!;
const bip44Path = "m/44'/60'/0'/0";

final walletProvider = StateNotifierProvider<_Provider, WalletState>((ref) {
  return _Provider();
});

class _Provider extends StateNotifier<WalletState> {
  _Provider() : super(const WalletState());

  Future<List<Account>> allAccount() async {
    final accounts = (await AccountListStore().getItem())!;
    final externalAccounts =
        (await ExternalAccountListStore().getItem()) ?? List.empty();
    List<Account> merged = [...accounts, ...externalAccounts];
    merged.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return merged;
  }

  Future<void> getBalance(Account account) async {
    final ethClient = Web3Client(_networkUrl, Client());
    final balance = await ethClient.getBalance(account.privateKey.address);
    await ethClient.dispose();

    state = state.copyWith(
        balance: balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(3));
  }

  Future<AppError?> init() async {
    try {
      state = state.copyWith(isLoading: true);

      final now = DateTime.now();

      final String? current = await MnemonicStore().getItem();
      if (current != null) {
        final primaryAccount = (await PrimaryAccountStore().getItem())!;

        state = state.copyWith(primaryAccount: primaryAccount);
        state = state.copyWith(accounts: await allAccount());

        await getBalance(primaryAccount);
      } else {
        final String mnemonic = bip39.generateMnemonic();
        final seed = bip39.mnemonicToSeed(mnemonic);
        final masterNode = bip32.BIP32.fromSeed(seed);
        final ethWalletNode = masterNode.derivePath("$bip44Path/0");

        final EthPrivateKey privateKey =
            EthPrivateKey.fromHex(HEX.encode(ethWalletNode.privateKey!));
        final EthereumAddress address = privateKey.address;
        final Uint8List publicKey = ethWalletNode.publicKey;

        debugPrint('mnemonic: $mnemonic');
        debugPrint('private Key: ${HEX.encode(privateKey.privateKey)}');
        debugPrint('public Key: ${bytesToHex(publicKey)}');
        debugPrint('ethereum address: $address');

        final account = Account(
            privateKey: privateKey,
            name: "Account1",
            fromMnemonic: true,
            createdAt: now);

        await MnemonicStore().setItem(mnemonic);
        await PrimaryAccountStore().setItem(account);
        await AccountListStore().setItem([account]);

        state = state.copyWith(primaryAccount: account);
        state = state.copyWith(accounts: [account]);

        await getBalance(account);
      }

      return null;
    } catch (e) {
      return AppError.defaultError();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<AppError?> refresh() async {
    try {
      await getBalance(state.primaryAccount!);

      return null;
    } catch (e) {
      return AppError.defaultError();
    }
  }

  Future<AppError?> changeAccount(Account account) async {
    try {
      await PrimaryAccountStore().setItem(account);

      state = state.copyWith(isLoading: true);
      state = state.copyWith(primaryAccount: account);

      await getBalance(account);

      return null;
    } catch (e) {
      return AppError.defaultError();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<AppError?> sendEther(double ether, String toAddress) async {
    try {
      state = state.copyWith(isLoading: true);

      if (ether <= 0.0 || toAddress.isEmpty) {
        return AppError(message: "入力が不正です");
      }

      final wei = BigInt.from(ether * 1e+18);
      final ethClient = Web3Client(_networkUrl, Client());
      final hash = await ethClient.sendTransaction(
          state.primaryAccount!.privateKey,
          Transaction(
              from: state.primaryAccount!.privateKey.address,
              to: EthereumAddress.fromHex(toAddress),
              value: EtherAmount.fromUnitAndValue(EtherUnit.wei, wei)),
          chainId: int.parse(_chainId));
      await ethClient.dispose();

      debugPrint("tx: $hash");

      return null;
    } catch (e) {
      return AppError.defaultError();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<AppError?> generateAccount() async {
    try {
      state = state.copyWith(isLoading: true);

      final now = DateTime.now();

      final allAccounts = await allAccount();
      final accounts = (await AccountListStore().getItem())!;

      final String mnemonic = (await MnemonicStore().getItem())!;
      final seed = bip39.mnemonicToSeed(mnemonic);
      final masterNode = bip32.BIP32.fromSeed(seed);
      final ethWalletNode =
          masterNode.derivePath("$bip44Path/${accounts.length}");

      final EthPrivateKey privateKey =
          EthPrivateKey.fromHex(HEX.encode(ethWalletNode.privateKey!));
      final EthereumAddress address = privateKey.address;
      final Uint8List publicKey = ethWalletNode.publicKey;

      debugPrint('mnemonic: $mnemonic');
      debugPrint('private Key: ${HEX.encode(privateKey.privateKey)}');
      debugPrint('public Key: ${bytesToHex(publicKey)}');
      debugPrint('ethereum address: $address');

      final account = Account(
          privateKey: privateKey,
          name: "Account${allAccounts.length + 1}",
          fromMnemonic: true,
          createdAt: now);

      accounts.add(account);
      allAccounts.add(account);

      await PrimaryAccountStore().setItem(account);
      await AccountListStore().setItem(accounts);

      state = state.copyWith(primaryAccount: account);
      state = state.copyWith(accounts: allAccounts);

      await getBalance(account);

      return null;
    } catch (e) {
      return AppError.defaultError();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<AppError?> importAccount(String rawPrivateKey) async {
    try {
      state = state.copyWith(isLoading: true);

      final now = DateTime.now();

      var allAccounts = await allAccount();
      var accounts = (await ExternalAccountListStore().getItem()) ??
          List.empty(growable: true);

      final privateKey = EthPrivateKey.fromHex("0x$rawPrivateKey");
      final EthereumAddress address = privateKey.address;

      debugPrint('private Key: ${HEX.encode(privateKey.privateKey)}');
      debugPrint('ethereum address: $address');

      final account = Account(
          privateKey: privateKey,
          name: "Account${allAccounts.length + 1}",
          fromMnemonic: false,
          createdAt: now);

      accounts.add(account);
      allAccounts.add(account);

      await PrimaryAccountStore().setItem(account);
      await ExternalAccountListStore().setItem(accounts);

      state = state.copyWith(primaryAccount: account);
      state = state.copyWith(accounts: allAccounts);

      await getBalance(account);

      return null;
    } catch (e) {
      debugPrint("error: ${e.toString()}");
      return AppError.defaultError();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<AppError?> restore(String mnemonic) async {
    try {
      state = state.copyWith(isLoading: true);

      final now = DateTime.now();

      await MnemonicStore().deleteItem();
      await PrimaryAccountStore().deleteItem();
      await AccountListStore().deleteItem();
      await ExternalAccountListStore().deleteItem();

      final seed = bip39.mnemonicToSeed(mnemonic);
      final masterNode = bip32.BIP32.fromSeed(seed);
      final ethWalletNode = masterNode.derivePath("$bip44Path/0");

      final EthPrivateKey privateKey =
          EthPrivateKey.fromHex(HEX.encode(ethWalletNode.privateKey!));
      final EthereumAddress address = privateKey.address;
      final Uint8List publicKey = ethWalletNode.publicKey;

      debugPrint('mnemonic: $mnemonic');
      debugPrint('private Key: ${HEX.encode(privateKey.privateKey)}');
      debugPrint('public Key: ${bytesToHex(publicKey)}');
      debugPrint('ethereum address: $address');

      final account = Account(
          privateKey: privateKey,
          name: "Account1",
          fromMnemonic: true,
          createdAt: now);

      await MnemonicStore().setItem(mnemonic);
      await PrimaryAccountStore().setItem(account);
      await AccountListStore().setItem([account]);

      state = state.copyWith(primaryAccount: account);
      state = state.copyWith(accounts: [account]);

      await getBalance(account);

      return null;
    } catch (e) {
      return AppError.defaultError();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Tuple2<String, AppError?>> exportPrivateKey() async {
    try {
      state = state.copyWith(isLoading: true);
      return Tuple2(
          HEX.encode(state.primaryAccount!.privateKey.privateKey), null);
    } catch (e) {
      return Tuple2("", AppError.defaultError());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<Tuple2<String, AppError?>> exportMnemonics() async {
    try {
      state = state.copyWith(isLoading: true);
      final String mnemonic = (await MnemonicStore().getItem())!;
      return Tuple2(mnemonic, null);
    } catch (e) {
      return Tuple2("", AppError.defaultError());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

@freezed
class WalletState with _$WalletState {
  const factory WalletState({
    @Default(false) bool isLoading,
    @Default(null) Account? primaryAccount,
    @Default("---") String balance,
    @Default([]) List<Account> accounts,
  }) = _WalletState;
}
