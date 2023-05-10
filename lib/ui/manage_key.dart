import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:hd_wallet_flutter/provider/wallet/wallet_provider.dart';
import 'package:hd_wallet_flutter/ui/component/button.dart';
import 'package:hd_wallet_flutter/ui/component/dialog.dart';
import 'package:hd_wallet_flutter/ui/component/text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ManageKeyPage extends HookConsumerWidget {
  const ManageKeyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletProvider);
    final action = ref.read(walletProvider.notifier);

    final isMounted = useIsMounted();
    final privateKey = useState("");
    final mnemonics = useState("");

    final generateButtonView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "秘密鍵を生成します。",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          ContainedButton(
            text: "秘密鍵の生成",
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            onClick: () async {
              final mounted = isMounted();

              final err = await action.generateAccount();
              if (err != null) {
                if (mounted) {
                  AppDialog().showErrorAlert(context, err);
                }
                return;
              }

              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );

    final importButtonView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "秘密鍵をインポートします。",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextFieldView(
            placeholder: "秘密鍵を入力",
            onChange: (val) {
              privateKey.value = val;
            },
          ),
          const SizedBox(height: 10),
          ContainedButton(
            text: "秘密鍵のインポート",
            backgroundColor:
                privateKey.value.isEmpty ? Colors.grey : Colors.blue,
            textColor: Colors.white,
            onClick: () async {
              final mounted = isMounted();

              final err = await action.importAccount(privateKey.value);
              if (err != null) {
                if (mounted) {
                  AppDialog().showErrorAlert(context, err);
                }
                return;
              }

              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );

    final restoreButtonView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 40, 10, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ニーモニックから秘密鍵を復元します。",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextFieldView(
            placeholder: "patrol moment olive ...",
            onChange: (val) {
              mnemonics.value = val;
            },
          ),
          const SizedBox(height: 10),
          ContainedButton(
            text: "復元",
            backgroundColor: mnemonics.value.isEmpty ? Colors.grey : Colors.red,
            textColor: Colors.white,
            onClick: () async {
              final mounted = isMounted();

              final err = await action.restore(mnemonics.value);
              if (err != null) {
                if (mounted) {
                  AppDialog().showErrorAlert(context, err);
                }
                return;
              }

              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text("秘密鍵の生成/インポート"),
          centerTitle: true,
        ),
      ),
      body: WidgetHUD(
          builder: (context) => ListView(
                children: [
                  generateButtonView,
                  importButtonView,
                  restoreButtonView
                ],
              ),
          showHUD: state.isLoading),
    );
  }
}
