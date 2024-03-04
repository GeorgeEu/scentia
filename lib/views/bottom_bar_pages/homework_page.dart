import 'package:scientia/widgets/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/homework/homework.dart';
import '../../services/home_work_data/homework_data.dart';

class Homework_Page extends StatefulWidget {
  const Homework_Page({Key? key}) : super(key: key);

  @override
  State<Homework_Page> createState() => _Homework_PageState();
}

class _Homework_PageState extends State<Homework_Page> {
  var _homework = HomeworkData();
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
            0: buildSegment('Week'),
            1: buildSegment('Month'),
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
            _buildHomeworkWidget()
          ],
        ),
      ),
    );
  }
  Widget _buildHomeworkWidget() {
    final weeklyHomework = _homework.getWeeklyHomework(1693917393000 + 1);
    switch (groupValue) {
      case 0:
        return Homework(weeklyHomework);
      case 1:
        return const Calendar();
      default:
        return Container();
    }
  }

  Widget buildSegment(String text) => Container(
    padding: const EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 6),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16
      ),
    ),
  );
}