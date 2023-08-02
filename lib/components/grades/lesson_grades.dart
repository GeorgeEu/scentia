import 'package:card_test/components/grades/grade_segment.dart';
import 'package:card_test/components/homework/homework_card.dart';
import 'package:flutter/material.dart';

import 'grade_card.dart';


class LessonGrades extends StatefulWidget {
  final List _grades;

  const LessonGrades(this._grades);

  @override
  State<LessonGrades> createState() => _LessonGradesState();
}

class _LessonGradesState extends State<LessonGrades> {
  @override
  Widget build(BuildContext context) {
    var gradesCount = widget._grades.length; //fix it later
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          GradeCard(widget._grades)
        ],
      ),
    );
  }
}
