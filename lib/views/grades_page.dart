import 'package:scientia/widgets/grades/lesson_grades.dart';
import 'package:scientia/widgets/substitutions/substitute_teachers.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/services/substitute_data/substitutions_data.dart';
import 'package:flutter/material.dart';


class GradesPage extends StatefulWidget {
  const GradesPage({Key? key}) : super(key: key);

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFA4A4FF),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Substitutions',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
          // titleSpacing: 0,
        ),
        body: Container(
          color: const Color(0xffefeff4),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                LessonGrades(),
              ],
            ),
          ),
        )
    );
  }
}

