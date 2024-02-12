import 'package:scientia/components/attendance/summary_attendance/attendace.dart';
import 'package:scientia/components/events/events.dart';
import 'package:scientia/components/schedule/weakly_schedule.dart';
import 'package:flutter/material.dart';
import 'package:scientia/data/events_data/events_data.dart';
import 'package:scientia/components/navigation_drawer.dart';
import 'package:scientia/data/schedule_data/schedule_data.dart';
import 'package:scientia/data/attendance_data/attendance_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scientia/data/firestore_data.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);


  @override
  State<Main_Page> createState() => _MainPageState();
}


class _MainPageState extends State<Main_Page> {
  var data = FirestoreData();
  final weeklySchedule = ScheduleData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final attendance = AttendanceData();
    final allAttendance = attendance.getAllAttendance(1693530061000);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          _showBottomSheet(context);
        },
        backgroundColor: Color(0xFFB7B7FF),
        elevation: 0,
        child: Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
        backgroundColor: const Color(0xFFF3F2F8),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Color(0xFFADADFF),
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            color: Colors.white,
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
          elevation: 0,
          title: const Text(
              "11A, American International School Progress",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(children: [
            WeeklySchedule(weeklySchedule.getWeeklySchedule(1678723200000)),
            Events(data.getEvents()),
            Attendace(allAttendance),
          ]),
        ));
  }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
                  child: Row(
                    children: [
                      Text(
                        'Create',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.backpack_rounded),
                  title: Text('Create a homework'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.mail_rounded),
                  title: Text('Send a message'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.announcement_rounded),
                  title: Text('Make an announcement'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.border_color_rounded),
                  title: Text('Give a grade'),
                  onTap: () {},
                ),
              ],
            ),
          );
        });

  }
}

