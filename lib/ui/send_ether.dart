import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:hd_wallet_flutter/ui/component/button.dart';
import 'package:hd_wallet_flutter/provider/wallet/wallet_provider.dart';
import 'package:hd_wallet_flutter/ui/component/dialog.dart';
import 'package:hd_wallet_flutter/ui/component/text_field.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SendEtherPage extends HookConsumerWidget {
  const SendEtherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletProvider);
    final action = ref.read(walletProvider.notifier);

    final isMounted = useIsMounted();
    final amount = useState("0.0");
    final toAddress = useState("");

    final fromView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 40, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            child: Text(
              "送主:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.primaryAccount?.name ?? "",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                "残高: ${state.balance} MATIC",
                style: const TextStyle(fontSize: 15),
              ),
            ],
          )
        ],
      ),
    );

    final toView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            child: Text(
              "宛先:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 80 - 20,
            child: TextFieldView(
              placeholder: "0x00...",
              inputType: TextInputType.emailAddress,
              onChange: (val) {
                toAddress.value = val;
              },
            ),
          )
        ],
      ),
    );

    final amountView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            child: Text(
              "総量:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 80 - 20,
            child: TextFieldView(
              placeholder: "0.1",
              inputType: TextInputType.number,
              onChange: (val) {
                amount.value = val;
              },
            ),
          )
        ],
      ),
    );

    final sendButtonView = Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: ContainedButton(
        text: "送信",
        backgroundColor: amount.value.isEmpty || toAddress.value.isEmpty
            ? Colors.grey
            : Colors.blue,
        textColor: Colors.white,
        onClick: () async {
          if (amount.value.isEmpty || toAddress.value.isEmpty) {
            return;
          }

          final mounted = isMounted();

          final err = await action.sendEther(
              double.parse(amount.value), toAddress.value);
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
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text(""),
          centerTitle: true,
        ),
      ),
      body: WidgetHUD(
          builder: (context) => Column(
                children: [
                  fromView,
                  toView,
                  amountView,
                  Expanded(child: Container()),
                  sendButtonView
                ],
              ),
          showHUD: state.isLoading),
    );
  }
}
