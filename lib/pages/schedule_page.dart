import 'package:card_test/components/calendar/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Schedule_Page extends StatefulWidget {
  const Schedule_Page({Key? key}) : super(key: key);

  @override
  State<Schedule_Page> createState() => _Schedule_PageState();
}

class _Schedule_PageState extends State<Schedule_Page> {
  late Map<String, dynamic> _day;
  late DateTime selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month; // Declare and initialize _calendarFormat

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffefeff4),
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16,bottom: 8, top: 32),
          child: Calendar()
        )
      ),
    );
  }
}
