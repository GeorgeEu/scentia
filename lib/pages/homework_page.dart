import 'package:card_test/components/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/home_work/full_hw/home_work.dart';
import '../components/home_work/week_homework/week_homework.dart';
import '../data/home_work_data/home_work_data.dart';
import '../data/home_work_data/week_howework_data.dart';

class Homework_Page extends StatefulWidget {
  const Homework_Page({Key? key}) : super(key: key);

  @override
  State<Homework_Page> createState() => _Homework_PageState();
}
enum Content { week, month }

class _Homework_PageState extends State<Homework_Page> {
  var tasks = HomeWorkData();
  var tmr_task = WeekHomeworkData();
  Content selectedContent = Content.week;

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
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SegmentedButton<Content>(
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 12,right: 12))
                    ),
                    segments: const <ButtonSegment<Content>>[
                      ButtonSegment<Content>(
                          value: Content.week,
                          label: Text('week')
                      ),
                      ButtonSegment<Content>(
                        value: Content.month,
                        label: Text('month'),
                      ),
                    ],
                    selected: <Content>{selectedContent},
                    onSelectionChanged: (Set<Content> newSelection) {
                      setState(() {
                        selectedContent = newSelection.first;
                      });
                    },
                  ),
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
                  if (selectedContent == Content.week)
                    WeekHomework(tmr_task.getWeekHomework()),
                  if (selectedContent == Content.month)
                    const Calendar(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}