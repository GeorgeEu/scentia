import 'package:flutter/material.dart';

class  SearchPeopleTextField extends StatefulWidget {
  @override
  _SearchPeopleTextFieldState createState() => _SearchPeopleTextFieldState();
}

class _SearchPeopleTextFieldState extends State<SearchPeopleTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        expands: false,
        controller: _controller,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey), // Change the color for focused state
            ),
            labelText: null,
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 30,
            ),
            hintText: 'Search',
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
