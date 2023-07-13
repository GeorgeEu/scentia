import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/grades/grades/grades.dart';
import '../components/grades/td_grades/todays_grades.dart';
import '../data/grades_data/grades_data.dart';
import '../data/grades_data/td_grades_data.dart';

class Grades_Page extends StatefulWidget {
  const Grades_Page({Key? key}) : super(key: key);

  @override
  State<Grades_Page> createState() => _Grades_PageState();
}


class _Grades_PageState extends State<Grades_Page> {
  var grades = GradesData();
  var td_grades = TdGradesData();
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
                      0: buildSegment('Recent'),
                      1: buildSegment('All'),
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
                  if (groupValue == 0)
                    TdGrades(td_grades.getTdGrades()),
                  if (groupValue == 1)
                    Grades(grades.getGrades()),
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
