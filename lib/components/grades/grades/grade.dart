import 'package:flutter/material.dart';


class Grade extends StatefulWidget {
  final Map<String, String> _grade;

  const Grade(this._grade, {super.key});

  @override
  State<Grade> createState() => _GradeState();
}

class _GradeState extends State<Grade> {
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
              widget._grade['Name'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            Text(
              widget._grade['Date'].toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
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
              widget._grade['Grade'].toString(),
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