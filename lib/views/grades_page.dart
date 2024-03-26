import 'package:scientia/widgets/grades/grade_card.dart';
import 'package:scientia/widgets/grades/daily_grades_test.dart';
import 'package:scientia/widgets/grades/lesson_grades.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/calendar/calendar.dart';
import '../../widgets/grades/grades.dart';
import '../../widgets/grades/weekly_grades_test.dart';
import '../../widgets/homework/homework.dart';
import '../../services/grades_data/grades_data.dart';

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
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xFFA4A4FF),
        title: CupertinoSlidingSegmentedControl<int>(
          backgroundColor: CupertinoColors.tertiarySystemFill,
          thumbColor: CupertinoColors.white,
          groupValue: groupValue,
          children: {
            0: buildSegment('Recent'),
            1: buildSegment('All')
          },
          onValueChanged: (groupValue) {
            setState(() {
              this.groupValue = groupValue;
            });
          },
        ),
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
    switch (groupValue) {
      case 0:
        return DailyGradesTest();
      case 1:
        return LessonGrades();
      default:
        return Container();
    }
  }

  Widget buildSegment(String text) => Container(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 16
      ),
    ),
  );
}
