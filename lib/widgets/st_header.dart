import 'package:flutter/material.dart';

class StHeader extends StatelessWidget {
  final String text;
  final FontWeight fontWeight = FontWeight.w500;
  final double fontSize = 20.5;

  StHeader({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        height: 1.2,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}
