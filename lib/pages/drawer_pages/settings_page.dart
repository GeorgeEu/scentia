import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFADADFF),
        title: Text(
            'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {Navigator.pop(context);}
        ),
      ),
      body: Center(
        child: Icon(Icons.settings_rounded,)
      ),
    );
  }
}
