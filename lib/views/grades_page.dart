import 'package:scientia/widgets/grades/lesson_grades.dart';
import 'package:flutter/material.dart';


class GradesPage extends StatefulWidget {
  List<Map<String, dynamic>> allGrades;
  GradesPage({super.key, required this.allGrades});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefeff4),
        appBar: AppBar(
          backgroundColor: Color(0xFFA4A4FF),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Grades',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
          // titleSpacing: 0,
        ),
        body: LessonGrades(allGrades: widget.allGrades)
    );
  }
}

