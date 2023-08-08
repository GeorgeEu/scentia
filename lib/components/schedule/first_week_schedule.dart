import 'package:card_test/components/schedule/day_item.dart';
import 'package:flutter/material.dart';
import 'package:card_test/data/schedule_data/schedule_data.dart';

class FirstWeekSchedule extends StatefulWidget {
  const FirstWeekSchedule({Key? key}) : super(key: key);

  @override
  State<FirstWeekSchedule> createState() => _FirstWeekScheduleState();
}

class _FirstWeekScheduleState extends State<FirstWeekSchedule> {

  @override
  Widget build(BuildContext context) {
    const int pageCount = 5;
    var lessons = ScheduleData();
    var days = lessons.getSchedule();

    return SizedBox(
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: pageCount,
        itemBuilder: (context, index) {
          return DayItem(days[index]);
        },
      ),
    );
  }
}
