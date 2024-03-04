import 'package:flutter/material.dart';

class  CreateGroupTextField extends StatefulWidget {
  @override
  _CreateGroupTextFieldState createState() => _CreateGroupTextFieldState();
}

class _CreateGroupTextFieldState extends State<CreateGroupTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 20,
      controller: _controller,
      decoration: InputDecoration(
          labelText: null,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700), // Change the color for focused state
          ),
          // prefixIcon: IconButton(
          //   onPressed: (){},
          //   icon: Icon(Icons.attach_file_rounded),
          // ),
          // suffixIcon: IconButton(
          //   onPressed: (){},
          //   icon: Icon(Icons.send_rounded),
          // ),
          hintText: 'Group name',
          fillColor: Colors.black12
        // You can customize other properties like prefixIcon, suffixIcon, etc.
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
