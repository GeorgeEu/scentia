import 'package:scientia/widgets/grades/lesson_grades_segment.dart';
import 'package:flutter/material.dart';

class LessonGrades extends StatefulWidget {
  final List _grades;

  const LessonGrades(this._grades);

  @override
  State<LessonGrades> createState() => _LessonGradesState();
}

class _LessonGradesState extends State<LessonGrades> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: widget._grades.length,
        itemBuilder: (context, index) {
          var grades = widget._grades[index];
          return LessonGradesSegment(grades);
        },
      ),
    );
  }
}
