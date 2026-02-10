import 'package:flutter/material.dart';

class ProcessButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final VoidCallback onPressed;
  final Color textColor;
  final double borderRadius;
  final double padding;

  const ProcessButton({
    super.key,
    required this.text,
    required this.buttonColor,
    required this.onPressed,
    this.textColor = Colors.white,
    this.borderRadius = 8.0,
    this.padding = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
