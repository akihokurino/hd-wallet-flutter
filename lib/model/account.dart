import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';

class Account {
  EthPrivateKey privateKey;
  String name;
  bool fromMnemonic;
  DateTime createdAt;

  Account(
      {required this.privateKey,
      required this.name,
      required this.fromMnemonic,
      required this.createdAt});

  Map<String, Object> encode() {
    final walletInfo = {
      "privateKey": HEX.encode(privateKey.privateKey),
      "name": name,
      "fromMnemonic": fromMnemonic,
      "createdAt": createdAt.millisecondsSinceEpoch
    };

    return walletInfo;
  }

  static Account decode(Map<String, dynamic> from) {
    final privateKey = from["privateKey"].toString();
    final name = from["name"].toString();
    final fromMnemonic = from["fromMnemonic"] as bool;
    final createdAt = from["createdAt"] as int;

    return Account(
        privateKey: EthPrivateKey.fromHex(privateKey),
        name: name,
        fromMnemonic: fromMnemonic,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt));
  }
}
