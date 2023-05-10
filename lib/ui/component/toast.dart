import 'dart:async';

import 'package:flutter/material.dart';

void showToast(
    BuildContext context, String message, Color color, VoidCallback onTap) {
  final entry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Text(
                message,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(entry);
  Timer(const Duration(seconds: 3), () {
    entry.remove();
  });
}
