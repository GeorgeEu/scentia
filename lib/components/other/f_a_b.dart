import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAB extends StatefulWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      elevation: 0,
      child: Icon(Icons.add),
    );
  }
}
