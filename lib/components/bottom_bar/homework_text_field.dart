import 'package:flutter/material.dart';

class HomeworkTextField extends StatefulWidget {
  @override
  _HomeworkTextFieldState createState() => _HomeworkTextFieldState();
}

class _HomeworkTextFieldState extends State<HomeworkTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Homework...',
          hintText: 'Type something',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)
          ),
          filled: true,
          fillColor: Colors.black12
          // You can customize other properties like prefixIcon, suffixIcon, etc.
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
