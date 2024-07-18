import 'package:flutter/material.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/widgets/homework/homework_card.dart';

class HomeworkPage extends StatefulWidget {
  final List<Map<String, dynamic>> homework;

  HomeworkPage({super.key, required this.homework});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F2F8),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xFFA4A4FF),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Homework',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),
        ),
      ),
      body: HomeworkCard(homework: widget.homework)
    );
  }
}
