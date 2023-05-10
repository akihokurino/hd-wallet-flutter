import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:hd_wallet_flutter/ui/component/dialog.dart';
import 'package:hd_wallet_flutter/provider/wallet/wallet_provider.dart';
import 'package:hd_wallet_flutter/ui/component/toast.dart';
import 'package:hd_wallet_flutter/ui/manage_key.dart';
import 'package:hd_wallet_flutter/ui/select_account.dart';
import 'package:hd_wallet_flutter/ui/send_ether.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WalletPage extends HookConsumerWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletProvider);
    final action = ref.read(walletProvider.notifier);

    final isMounted = useIsMounted();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.wait([action.init()]).then((err) {
          final errors = err.where((element) => element != null).toList();
          if (errors.isNotEmpty) {
            AppDialog().showErrorAlert(context, errors.first!);
            return;
          }
        });
      });

      return () {};
    }, const []);

    final accountView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
      child: Text(
        state.primaryAccount?.name ?? "",
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );

    final balanceView = Container(
      width: double.infinity,
      height: 80.0,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Card(
        color: Colors.blue,
        child: Center(
          child: Text(
            "${state.balance} MATIC",
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    final addressView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Text(
        state.primaryAccount?.privateKey.address.hex ?? "",
        style: const TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );

    final actionView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {},
              child: Column(
                children: const [
                  Icon(Icons.arrow_circle_down_outlined),
                  Text("受取")
                ],
              )),
          const SizedBox(
            width: 50,
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SendEtherPage(),
                  ),
                );
              },
              child: Column(
                children: const [
                  Icon(Icons.arrow_circle_up_outlined),
                  Text("送信")
                ],
              ))
        ],
      ),
    );

    void actionSheet() {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: const Text('アカウント選択'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SelectAccountPage(),
                    ),
                  );
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('秘密鍵のインポート'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ManageKeyPage(),
                    ),
                  );
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('秘密鍵のエクスポート'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  final mounted = isMounted();

                  final res = await action.exportPrivateKey();
                  if (res.item2 != null) {
                    if (mounted) {
                      AppDialog().showErrorAlert(context, res.item2);
                    }
                    return;
                  }

                  if (mounted) {
                    showToast(context, res.item1, Colors.red, () async {
                      await Clipboard.setData(ClipboardData(text: res.item1));
                    });
                  }
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('ニーモニックのエクスポート'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  final mounted = isMounted();

                  final res = await action.exportMnemonics();
                  if (res.item2 != null) {
                    if (mounted) {
                      AppDialog().showErrorAlert(context, res.item2);
                    }
                    return;
                  }

                  if (mounted) {
                    showToast(context, res.item1, Colors.red, () async {
                      await Clipboard.setData(ClipboardData(text: res.item1));
                    });
                  }
                },
              ),
            ],
            cancelButton: CupertinoButton(
              child: const Text('キャンセル'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text("Mumbai Network"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () => {actionSheet()},
            ),
          ],
        ),
      ),
      body: WidgetHUD(
          builder: (context) => RefreshIndicator(
                child: ListView(
                  children: [accountView, balanceView, addressView, actionView],
                ),
                onRefresh: () async {
                  final mounted = isMounted();

                  final err = await action.refresh();
                  if (err != null) {
                    if (mounted) {
                      AppDialog().showErrorAlert(context, err);
                    }
                    return;
                  }
                },
              ),
          showHUD: state.isLoading),
    );
  }
}
