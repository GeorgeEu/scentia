import 'package:flutter/material.dart';

class StSnackBar extends SnackBar {
  StSnackBar({
    required String message,
    VoidCallback? onActionPressed,
    String? actionLabel,
    Duration duration = const Duration(seconds: 3),
  }) : super(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          message,
          style: TextStyle(color: Colors.white, height: 1), // Custom text style
        ),
      ],
    ),
    backgroundColor: Colors.blueGrey, // Custom background color
    behavior: SnackBarBehavior.fixed,
    shape: null,
    duration: duration, // Set the duration for the SnackBar
  );
}
