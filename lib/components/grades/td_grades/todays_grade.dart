import 'package:flutter/material.dart';

class TdGrade extends StatefulWidget {
  final Map<String, String> _td_grade;

  const TdGrade(this._td_grade, {super.key});

  @override
  State<TdGrade> createState() => _TdGradeState();
}

class _TdGradeState extends State<TdGrade> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            Text(
              widget._td_grade['Name'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            alignment: Alignment.center,
            width: 28,
            height: 28,
            child: Text(
              widget._td_grade['Grade'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );

  }
}