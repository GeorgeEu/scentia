import 'package:flutter/material.dart';

class TmrLessonHW extends StatefulWidget {
  final Map<String, String> _tmr_task;

  TmrLessonHW(this._tmr_task);

  @override
  State<TmrLessonHW> createState() => _TmrLessonHWState();
}

class _TmrLessonHWState extends State<TmrLessonHW> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Text(
          widget._tmr_task['Name'].toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        Text(
          widget._tmr_task['Task'].toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}