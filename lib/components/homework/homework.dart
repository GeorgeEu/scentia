import 'package:flutter/material.dart';

import 'homework_segment.dart';

class Homework extends StatefulWidget {
  final List _homework;

  const Homework(this._homework);

  @override
  State<Homework> createState() => _HomeworkState();
}

class _HomeworkState extends State<Homework> {
  String formatDate(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.day}-${dateTime.month}';
  }
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._homework.length;
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          Container(
            height: homeworkCount * 80,
            padding: const EdgeInsets.only(top: 8),
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: homeworkCount,
              itemBuilder: (context, index) {
                return HomeworkSegment(widget._homework[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 0.5,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
