// import 'package:flutter/material.dart';
// import 'package:scientia/components/grades/daily_grades_test.dart';
//
// class WeeklyGradesTest extends StatefulWidget {
//   final int currentDay;
//   const WeeklyGradesTest(this.currentDay);
//
//   @override
//   State<WeeklyGradesTest> createState() => _WeeklyGradesTestState();
// }
//
// class _WeeklyGradesTestState extends State<WeeklyGradesTest> {
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> daysWidgets = [];
//     final int day = 24 * 60 * 60 * 1000;
//
//     for (int i = 0; i < 7; i = i + 1) {
//       daysWidgets.add(DailyGradesTest(widget.currentDay + i * day));
//     }
//
//     return Column(
//       children: daysWidgets,
//     );
//   }
// }
