import 'package:flutter/material.dart';

class LessonHW extends StatefulWidget {
  final Map<String, String> _task;

  LessonHW(this._task);

  @override
  State<LessonHW> createState() => _LessonHWState();
}

class _LessonHWState extends State<LessonHW> {
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
              widget._task['Name'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ],
    );

  }
}
