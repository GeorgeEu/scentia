import 'package:flutter/material.dart';

class CustomColumn extends StatelessWidget {
  final List<Widget> children;

  CustomColumn({required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.0,  // Set the height to 52 pixels
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
