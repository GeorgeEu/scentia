import 'package:card_test/components/grades/td_grades/todays_grade.dart';

import '';
import 'package:flutter/material.dart';

class TdGrades extends StatefulWidget {
  final List _td_grades;
  const TdGrades(this._td_grades);

  @override
  State<TdGrades> createState() => _TdGradesState();
}

class _TdGradesState extends State<TdGrades> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._td_grades.length;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Container(
        height: homeworkCount * 44,
        padding: const EdgeInsets.only(top: 8),
        child: ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: homeworkCount,
          itemBuilder: (context, index) {
            return TdGrade(widget._td_grades[index]);
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 0.5,
            );
          },
        ),
      ),
    );
  }
}