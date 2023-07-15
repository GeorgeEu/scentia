import 'package:flutter/material.dart';

class HomeworkSegment extends StatefulWidget {
  final Map<String, dynamic> _homework;

  HomeworkSegment(this._homework);

  @override
  State<HomeworkSegment> createState() => _HomeworkSegmentState();
}

class _HomeworkSegmentState extends State<HomeworkSegment> {
  String formatDate(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Text(
          formatDate(widget._homework['Date']),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                  widget._homework['Name'].toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.grey)),
            ),
            Expanded(
              child: Text(
                widget._homework['Task'].toString(),
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
