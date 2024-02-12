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
      backgroundColor: const Color(0xFFF3F2F8),
      appBar: AppBar(

        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        surfaceTintColor: Colors.transparent,
          backgroundColor: Color(0xFFADADFF),
        title: CupertinoSlidingSegmentedControl<int>(
          backgroundColor: CupertinoColors.tertiarySystemFill,
          thumbColor: CupertinoColors.white,
          groupValue: groupValue,
          children: {
            0: buildSegment('Current'),
            1: buildSegment('Upcoming')
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
            _buildScheduleWidget()
          ],
        ),
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
  Widget buildSegment(String text) => Container(
    padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 16
      ),
    ),
  );
}
