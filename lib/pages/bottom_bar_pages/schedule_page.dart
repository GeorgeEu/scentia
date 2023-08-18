import 'package:scientia/components/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/schedule/first_week_schedule.dart';
//import '../../data/schedule_data/schedule_data.dart';
import "package:scientia/data/schedule_data/schedule_data.dart";

class Schedule_Page extends StatefulWidget {
  const Schedule_Page({Key? key}) : super(key: key);

  @override
  State<Schedule_Page> createState() => _Schedule_PageState();
}

class _Schedule_PageState extends State<Schedule_Page> {
  late Map<String, dynamic> _day;
  int? groupValue = 0;
  final schedule = ScheduleData();

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
                      0: buildSegment('This Week'),
                      1: buildSegment('Next Week')
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
              _buildScheduleWidget()
            ],
          ),
        )
      ),
    );
  }
  Widget _buildScheduleWidget() {
    final firstWeekSchedule = schedule.getWeeklySchedule(1678723200000);
    final secondWeekSchedule = schedule.getSecondWeekSchedule(1678723200000);
    switch (groupValue) {
      case 0:
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: FirstWeekSchedule(firstWeekSchedule),
        );
      case 1:
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: FirstWeekSchedule(secondWeekSchedule),
        );
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
