import 'package:card_test/components/home_work/week_homework/week_segment_homework.dart';
import 'package:flutter/material.dart';

class WeekHomework extends StatefulWidget {
  final List _homework;
  const WeekHomework(this._homework);

  @override
  State<WeekHomework> createState() => _WeekHomeworkState();
}

class _WeekHomeworkState extends State<WeekHomework> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._homework.length;
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Container(
        height: homeworkCount * 80,
        padding: const EdgeInsets.only(top: 8),
        child: ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: homeworkCount,
          itemBuilder: (context, index) {
            return WeekSegmentHomework(widget._homework[index]);
          },
          separatorBuilder: (context, index) {
            return const Divider(
                thickness: 0.5,
            );
          },
        ),
      ),
    );
  }
}