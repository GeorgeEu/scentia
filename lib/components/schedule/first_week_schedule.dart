import 'package:scientia/components/schedule/day_item.dart';
import 'package:flutter/material.dart';
//import 'package:card_test/data/schedule_data/schedule_data.dart';

class FirstWeekSchedule extends StatefulWidget {
  List firstWeekSchedule;
  FirstWeekSchedule(this.firstWeekSchedule, {super.key});

  @override
  State<FirstWeekSchedule> createState() => _FirstWeekScheduleState();
}

class _FirstWeekScheduleState extends State<FirstWeekSchedule> {

  @override
  Widget build(BuildContext context) {
    //var lessons = ScheduleData();
    List days = widget.firstWeekSchedule;
    // print(days);

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: 7,
        itemBuilder: (context, index) {
          return DayItem(days[index]);
        },
      ),
    );
  }
}
