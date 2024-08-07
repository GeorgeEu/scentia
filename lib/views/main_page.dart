import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/models/events_model.dart';
import 'package:scientia/services/attendance_calc.dart';
import 'package:scientia/widgets/attendance/attendace.dart';
import 'package:scientia/widgets/content_column.dart';
import 'package:scientia/widgets/events/events.dart';
import 'package:scientia/widgets/grades/recent_grades.dart';
import 'package:scientia/services/schedule_service.dart';
import 'package:scientia/widgets/history.dart';
import 'package:scientia/widgets/homework/recent_homework.dart';
import 'package:scientia/widgets/schedule/weakly_schedule.dart';
import 'package:flutter/material.dart';
import 'package:scientia/widgets/navigation_drawer.dart';
import 'package:scientia/services/firestore_data.dart';

import '../models/attendance_model.dart';
import '../models/daily_schedule.dart';
import '../models/daily_teacher_schedule.dart';
import '../models/grades_model.dart';
import '../models/homework_model.dart';
import '../services/auth_services.dart';
import '../services/teacher_schedule.dart';
import 'hw_creating_page.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({super.key});

  @override
  State<Main_Page> createState() => _MainPageState();
}

class _MainPageState extends State<Main_Page> {
  var data = FirestoreData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> homework = [];
  List<Map<String, dynamic>> attendance = [];
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> grades = [];
  List<Map<String, dynamic>> allGrades = [];
  Map<String, double> absencePercentageMap = {};
  Map<String, int> attendanceCount = {};
  List<DailySchedule> schedule = [];
  List<DailyTeacherSchedule> teachSchedule = [];
  String? userStatus;
  bool isLoading = true;

  Future<void> _getHomework() async {
    homework = await HomeworkModel().fetchHomework();
  }

  Future<void> _getAttendancePerc() async {
    absencePercentageMap = await AttendanceCalc().calculateAbsencePercentagePerSubject();
  }

  Future<void> _getAttendance() async {
    attendance = await AttendanceModel().fetchAttendance();
  }

  Future<void> _getAttendanceCount() async {
    attendanceCount = await AttendanceModel().fetchAttendanceCounts();
  }

  Future<void> _getEvents() async {
    events = await EventsModel().fetchEvents();
  }

  Future<void> _getGrades() async {
    grades = await GradesModel().fetchGrades();
  }

  Future<void> _getAllGrades() async {
    allGrades = await GradesModel().getSubjectGrades();
  }

  Future<void> _fetchUserStatus() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('account')
            .doc('permission')
            .get();

        // Ensure the document exists and cast the data to a Map
        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;
          setState(() {
            userStatus = data?['status'];
          });
        }
      } catch (e) {
        print("Error fetching user status: $e");
      }
    }
  }


  Future<void> _getWeeklySchedule() async {
    final DateTime now = DateTime.now();
    final Timestamp currTimestamp = Timestamp.fromDate(now);
    final weeklySchedule = ScheduleService(timestamp: currTimestamp);
    schedule = await weeklySchedule.getWeeklySchedule();
  }

  Future<void> _getWeeklyTeacherSchedule() async {
    final DateTime now = DateTime.now();
    final Timestamp currTimestamp = Timestamp.fromDate(now);
    final teacherSchedule = TeacherSchedule(timestamp: currTimestamp);
    teachSchedule = await teacherSchedule.getWeeklyTeacherSchedule();
  }

  @override
  void initState() {
    super.initState();
    _loadData().then((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      _fetchUserStatus(),
      _getHomework(),
      _getAttendance(),
      _getAttendancePerc(),
      _getGrades(),
      _getAttendanceCount(),
      _getAllGrades(),
      _getEvents(),
      _getWeeklyTeacherSchedule(),
      _getWeeklySchedule(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isLoading && userStatus == 'teacher'
          ? FloatingActionButton(
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
      )
          : null,
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
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      drawer: MyDrawer(
        attendance: attendance,
        homework: homework,
        grades: grades,
        absencePercentageMap: absencePercentageMap,
        allGrades: allGrades,
        events: events,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            WeeklySchedule(
              schedule: userStatus == 'teacher' ? teachSchedule : schedule,
            ),
            if (userStatus == 'teacher')
              const History()
            else
              ContentColumn(
                children: [
                  RecentGrades(grades: grades, allGrades: allGrades),
                  RecentHomework(homework: homework),
                  Events(events: events),
                  Attendace(
                      attendance: attendance,
                      attendanceCount: attendanceCount,
                      absencePercentageMap: absencePercentageMap),
                ],
              ),
          ],
        ),
      ),
    );
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
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HwCreatingPage()),
                  );
                },
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
