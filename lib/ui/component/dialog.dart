import 'package:flutter/material.dart';
import 'package:hd_wallet_flutter/ui/component/button.dart';

class AppDialog {
  static final AppDialog _singleton = AppDialog._internal();

  factory AppDialog() {
    return _singleton;
  }

  AppDialog._internal();

  bool _isShown = false;

  void showErrorAlert(BuildContext context, dynamic e) {
    if (_isShown) {
      return;
    }

    _isShown = true;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content:
              Text(e.toString(), style: ThemeData.dark().textTheme.bodyLarge),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.zero,
              width: 80,
              child: GhostButton(
                  text: "閉じる",
                  color: ThemeData.dark().textTheme.bodyLarge!.color!,
                  onClick: () {
                    Navigator.pop(context);
                  }),
            ),
          ],
        );
      },
    ).then((res) async {
      _isShown = false;
    });
  }
}
