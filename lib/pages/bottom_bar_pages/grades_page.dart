import 'package:scientia/components/grades/grade_card.dart';
import 'package:scientia/components/grades/grades_test.dart';
import 'package:scientia/components/grades/lesson_grades.dart';
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
  final _grades = GradesData();
  int? groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F8),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
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
                      1: buildSegment('All')
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildGradesWidget()
          ],
        ),
      ),
    );
  }
  Widget _buildGradesWidget() {
    final weeklyGrades = _grades.getWeeklyGrades(1693917393000 + 1);
    final grades = _grades.getSubjectGrades();
    switch (groupValue) {
      case 0:
        return GradeCard(weeklyGrades);
      case 1:
        return LessonGrades(grades);
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
