import 'package:flutter/material.dart';

class StDropdownField extends StatelessWidget {
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final String labelText;

  StDropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent, // Removes splash color
        highlightColor: Colors.transparent, // Removes highlight color
        dividerColor: Colors.transparent,
        // Removes divider
      ),
      child: DropdownButtonFormField<String>(
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
        dropdownColor: Colors.white,
        value: value,
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
          labelStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.grey.shade700),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
