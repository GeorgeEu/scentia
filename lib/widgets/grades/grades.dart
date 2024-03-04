import 'package:scientia/widgets/homework/homework_card.dart';
import 'package:flutter/material.dart';

import 'grade_card.dart';


class Grades extends StatefulWidget {
  final List _grades;

  const Grades(this._grades);

  @override
  State<Grades> createState() => _GradesState();
}

class _GradesState extends State<Grades> {
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
