import 'package:card_test/components/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/homework/homework.dart';
import '../data/home_work_data/homework_data.dart';

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
              _buildHomeworkWidget()
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHomeworkWidget() {
    switch (groupValue) {
      case 0:
        return Homework(_homework.getHomework());
      case 1:
        return const Calendar();
      default:
        return Container();
    }
  }

  Widget buildSegment(String text) => Container(
    padding: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
    child: Text(
      text,
    ),
  );
}