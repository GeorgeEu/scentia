import 'package:card_test/components/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/home_work/week_homework/week_homework.dart';
import '../data/home_work_data/home_work_data.dart';
import '../data/home_work_data/week_homework_data.dart';

class Homework_Page extends StatefulWidget {
  const Homework_Page({Key? key}) : super(key: key);

  @override
  State<Homework_Page> createState() => _Homework_PageState();
}

class _Homework_PageState extends State<Homework_Page> {
  var tasks = HomeWorkData();
  var tmr_task = WeekHomeworkData();
  int? groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffefeff4),
        actions: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 4, top: 4),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: CupertinoColors.tertiarySystemFill,
                    thumbColor: CupertinoColors.white,
                    groupValue: groupValue,
                    children: {
                      0: buildSegment('Week'),
                      1: buildSegment('Month'),
                    },
                    onValueChanged: (groupValue) {
                      print(groupValue);

                      setState(() {
                        this.groupValue = groupValue;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        color: const Color(0xffefeff4),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  if (groupValue == 0) WeekHomework(tmr_task.getWeekHomework()),
                  if (groupValue == 1) const Calendar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildSegment(String text) => Container(
    padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
    child: Text(
      text,
    ),
  );
}
