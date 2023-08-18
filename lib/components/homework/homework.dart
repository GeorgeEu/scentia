import 'package:scientia/components/homework/homework_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'homework_segment.dart';

class Homework extends StatefulWidget {
  final List _homework;

  const Homework(this._homework);

  @override
  State<Homework> createState() => _HomeworkState();
}

class _HomeworkState extends State<Homework> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._homework.length; //fix it later
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          HomeworkCard(widget._homework)
        ],
      ),
    );
  }
}
