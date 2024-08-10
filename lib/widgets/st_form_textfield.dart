import 'package:flutter/material.dart';

class StFormTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;
  final String? Function(String?)? validator;

  StFormTextfield({
    required this.controller,
    required this.labelText,
    this.maxLines = 4,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white, // Background color of the input field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Border roundness
          borderSide: BorderSide(
            color: Colors.grey.shade300, // Border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Border roundness
          borderSide: BorderSide(
            color: Colors.blue, // Border color when focused
            width: 2.0, // Border width when focused
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Border roundness
          borderSide: BorderSide(
            color: Colors.grey.shade300, // Border color when enabled
            width: 1.0, // Border width when enabled
          ),
        ),

        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade700), // Label text color and style
      ),
      cursorColor: Colors.blue,
      cursorHeight: 20,
      maxLines: maxLines, // Number of lines to show
      validator: validator,
    );
  }
}
