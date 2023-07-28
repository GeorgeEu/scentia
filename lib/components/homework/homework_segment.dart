import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeworkSegment extends StatefulWidget {
  final Map<String, dynamic> _homework;

  HomeworkSegment(this._homework);

  @override
  State<HomeworkSegment> createState() => _HomeworkSegmentState();
}

class _HomeworkSegmentState extends State<HomeworkSegment> {
  String formatDate(int timestamp) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String fdatetime = DateFormat('MMM dd, yyyy').format(tsdate); // Corrected the format string to 'yyyy'
    return fdatetime;
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