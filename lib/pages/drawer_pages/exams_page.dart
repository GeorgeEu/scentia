import 'package:flutter/material.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({Key? key}) : super(key: key);

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {Navigator.pop(context);}
        ),
        title: Text(
            'Exams'
        ),
      ),
      body: Center(
        child: Icon(Icons.school_rounded),
      ),
    );
  }
}
