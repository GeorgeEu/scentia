import 'package:flutter/material.dart';

class ContentColumn extends StatelessWidget {
  final List<Widget> children;

  const ContentColumn({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }
}