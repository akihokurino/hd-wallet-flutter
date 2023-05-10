import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:hd_wallet_flutter/model/account.dart';
import 'package:hd_wallet_flutter/provider/wallet/wallet_provider.dart';
import 'package:hd_wallet_flutter/ui/component/dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SelectAccountPage extends HookConsumerWidget {
  const SelectAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletProvider);
    final action = ref.read(walletProvider.notifier);

    final isMounted = useIsMounted();

    TextButton createAccountView(Account account) {
      return TextButton(
          onPressed: () async {
            final mounted = isMounted();

            final err = await action.changeAccount(account);
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
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      account.privateKey.address.hex,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Icon(
                      Icons.check_circle_outline,
                      color: account.privateKey.address.hex ==
                              state.primaryAccount!.privateKey.address.hex
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text(""),
          centerTitle: true,
        ),
      ),
      body: WidgetHUD(
          builder: (context) => ListView(
                children:
                    state.accounts.map((e) => createAccountView(e)).toList(),
              ),
          showHUD: state.isLoading),
    );
  }
}
