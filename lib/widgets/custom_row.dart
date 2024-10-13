import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onTap;

  CustomRow({required this.children, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,  // Transparent background to maintain your custom style
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.shade300, // Customize the splash color
        child: Container(
          padding: EdgeInsets.only(left: 24),
          height: 52.0,  // Set the height to 52 pixels
          width: double.infinity,
          color: Colors.transparent,  // Keep container transparent if needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
