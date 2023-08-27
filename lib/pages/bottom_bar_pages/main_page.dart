import 'package:scientia/components/attendance/summary_attendance/attendace.dart';
import 'package:scientia/components/events/events.dart';
import 'package:scientia/components/schedule/weakly_schedule.dart';
import 'package:flutter/material.dart';
import 'package:scientia/data/events_data/events_data.dart';
import 'package:scientia/components/navigation_drawer.dart';
import 'package:scientia/data/schedule_data/schedule_data.dart';
import 'package:scientia/data/attendance_data/attendance_data.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);


  @override
  State<Main_Page> createState() => _MainPageState();
}

class _MainPageState extends State<Main_Page> {
  var events = EventsData();
  final weeklySchedule = ScheduleData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final attendance = AttendanceData();
    final allAttendance = attendance.getAllAttendance(1630453200000);
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
          elevation: 0,
          backgroundColor: const Color(0xffefeff4),
          title: const Text("11A, American International School Progress"),
        ),
        drawer: MyDrawer(),
        body: Container(
          color: const Color(0xffefeff4),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(children: [
              WeeklySchedule(weeklySchedule.getWeeklySchedule(1678723200000)),
              Events(events.getEvents()),
              Attendace(allAttendance),
            ]),
          ),
        ));
  }
}
