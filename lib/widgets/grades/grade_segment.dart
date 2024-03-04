import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GradeSegment extends StatefulWidget {
  final Map<String, dynamic> _grades;

  GradeSegment(this._grades);

  @override
  State<GradeSegment> createState() => _GradeSegmentState();
}

class _GradeSegmentState extends State<GradeSegment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Text(
          widget._grades['Lesson'].toString(),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Text(
          widget._grades['Grade'].toString(),
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }
}
