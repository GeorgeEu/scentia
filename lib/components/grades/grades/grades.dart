import 'package:card_test/components/grades/grades/grade.dart';
import 'package:flutter/material.dart';

class Grades extends StatefulWidget {
  final List _grades;
  const Grades(this._grades);

  @override
  State<Grades> createState() => _GradesState();
}

class _GradesState extends State<Grades> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._grades.length;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Container(
        height: homeworkCount * 69,
        padding: const EdgeInsets.only(top: 8),
        child: ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: homeworkCount,
          itemBuilder: (context, index) {
            return Grade(widget._grades[index]);
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
