import 'package:flutter/material.dart';

class ContainedButton extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final VoidCallback onClick;
  final VoidCallback? onLongPressed;

  const ContainedButton({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 16,
    required this.backgroundColor,
    required this.textColor,
    this.width = double.infinity,
    this.height = 48,
    required this.onClick,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 5.0,
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
          ),
        ),
        onPressed: onClick,
        onLongPress: onLongPressed,
        child: Text(text,
            style: TextStyle(
                color: textColor, fontWeight: fontWeight, fontSize: fontSize)),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color color;
  final double width;
  final double height;
  final VoidCallback onClick;

  const GhostButton(
      {super.key,
      required this.text,
      this.fontWeight = FontWeight.w700,
      this.fontSize = 16,
      required this.color,
      this.width = double.infinity,
      this.height = 48,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
          backgroundColor: Colors.transparent,
        ),
        child: Text(text,
            style: TextStyle(
                color: color, fontWeight: fontWeight, fontSize: fontSize)),
        onPressed: () {
          onClick();
        },
      ),
    );
  }
}
