import 'package:scientia/models/daily_schedule.dart';
import 'package:scientia/widgets/attendance/summary_attendance/attendace.dart';
import 'package:scientia/widgets/events/events.dart';
import 'package:scientia/widgets/grades/recent_grades.dart';
import 'package:scientia/services/schedule_service.dart';
import 'package:scientia/widgets/homework/recent_homework.dart';
import 'package:scientia/widgets/schedule/weakly_schedule.dart';
import 'package:flutter/material.dart';
import 'package:scientia/widgets/navigation_drawer.dart';
import 'package:scientia/services/attendance_data/attendance_data.dart';
import 'package:scientia/services/firestore_data.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({super.key});

  final Set<String> weekday = const {
    "SUN",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT"
  };

  @override
  State<Main_Page> createState() => _MainPageState();
}


class _MainPageState extends State<Main_Page> {
  var data = FirestoreData();
  final weeklySchedule = ScheduleService(cls: '12b');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DailySchedule> weeklyData = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyData = weeklySchedule.getWeeklySchedule();
    final attendance = AttendanceData();
    final allAttendance = attendance.getAllAttendance(1693530061000);

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          isExtended: true,
          onPressed: () {
            _showBottomSheet(context);
          },
          backgroundColor: const Color(0xFFB7B7FF),
          elevation: 0,
          child: const Icon(
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
          backgroundColor: const Color(0xFFA4A4FF),
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
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
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: Column(children: [
            WeeklySchedule(weeklyData),
            const RecentGrades(),
            const RecentHomework(),
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
                child: Row(
                  children: [
                    const Text(
                      'Create',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
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
                leading: const Icon(Icons.backpack_rounded),
                title: const Text('Create a homework'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.mail_rounded),
                title: const Text('Send a message'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.announcement_rounded),
                title: const Text('Make an announcement'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.border_color_rounded),
                title: const Text('Give a grade'),
                onTap: () {},
              ),
            ],
          );
        });

  }
}
