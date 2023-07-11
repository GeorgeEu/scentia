import 'package:flutter/material.dart';

class WeekSegmentHomework extends StatefulWidget {
  final Map<String, dynamic> _week_homework;

  WeekSegmentHomework(this._week_homework);

  @override
  State<WeekSegmentHomework> createState() => _WeekSegmentHomeworkState();
}

class _WeekSegmentHomeworkState extends State<WeekSegmentHomework> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Text(
          widget._week_homework['Day'].toString(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        for (var segment in widget._week_homework["Schedule"])
        Row(
          children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  segment['Name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey)
                ),
              ),
            Expanded(
              child: Text(
                segment['Task'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 23),
              ),
            ),
          ],
        )
      ],
    );
  }
}
