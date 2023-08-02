import 'package:card_test/components/grades/lesson_grades.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/calendar/calendar.dart';
import '../../components/grades/grades.dart';
import '../../components/homework/homework.dart';
import '../../data/grades_data/grades_data.dart';

class Grades_Page extends StatefulWidget {
  const Grades_Page({Key? key}) : super(key: key);

  @override
  State<Grades_Page> createState() => _Grades_PageState();
}


class _Grades_PageState extends State<Grades_Page> {
  var _grades = GradesData();
  int? groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffefeff4),
        actions: [
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
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
                      2: buildSegment('All')
                    },
                    onValueChanged: (groupValue) {
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
          child: Column(
            children: [
              _buildGradesWidget()
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildGradesWidget() {
    final weeklyGrades = _grades.getWeeklyGrades(1693917393000 + 1);
    switch (groupValue) {
      case 0:
        return Grades(weeklyGrades);
      case 1:
        return const Calendar();
      case 2:
        return Calendar();
      default:
        return Container();
    }
  }

  Widget buildSegment(String text) =>
      Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
        child: Text(
          text,
        ),
      );
}
