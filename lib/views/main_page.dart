import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/models/events_model.dart';
import 'package:scientia/services/attendance_calc.dart';
import 'package:scientia/services/grade_creation_service.dart';
import 'package:scientia/utils/accounting.dart';
import 'package:scientia/views/grade_creating_page.dart';
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
import '../services/cloud_functions.dart';
import '../services/school_service.dart';
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
  SchoolService schoolService = SchoolService();
  CloudFunctions cloudFunctions = CloudFunctions();
  List<Map<String, dynamic>> homework = [];
  List<Map<String, dynamic>> attendance = [];
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> grades = [];
  List<Map<String, dynamic>> allGrades = [];
  Map<String, double> absencePercentageMap = {};

  List<Class> classes = [];
  List<Subject> subjects = [];
  List<Student> students = [];
  late String teacherName;

  Map<String, int> attendanceCount = {};
  List<DailySchedule> schedule = [];
  List<DailyTeacherSchedule> teachSchedule = [];

  String userStatus = ''; // Nullable type
  String schoolId = '';

  bool isLoading = true;
  bool isDataLoading = true;

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
        // Log the read operation (1 document read)
        await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 1);

        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;
          if (mounted) {
            // Check if the widget is still mounted
            setState(() {
              userStatus = data?['status'];
            });
          }
        }
      } catch (e) {
        print("Error fetching user status: $e");
      }
    }
  }

  Future<void> _getHomework() async {
    homework = await HomeworkModel().fetchHomework();
  }

  Future<void> _getSchoolId() async {
    schoolId = (await schoolService.getCurrentUserSchoolId())!;
  }

  Future<void> _getSubjects() async {
    subjects = await GradeCreationService().fetchSubjects();
  }

  Future<void> _getStudentsAndClasses() async {
    classes = await GradeCreationService().fetchClasses();
    students = await GradeCreationService().fetchStudentsForClasses(classes);
  }

  Future<void> _getTeacherName() async {
    teacherName = await GradeCreationService().fetchTeacherName();
  }

  Future<void> _getAttendancePerc() async {
    absencePercentageMap =
        await AttendanceCalc().calculateAbsencePercentagePerSubject();
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

  Future<void> _loadData() async {
    // Fetch user status first
    await _fetchUserStatus();

    // Check if userStatus is properly set
    if (userStatus.isEmpty) {
      print("User status is not set.");
      return; // Or handle the case where userStatus is not available
    }

    // Based on userStatus, fetch other data
    await Future.wait([
      if (userStatus == 'owner') ...[],
      if (userStatus == 'teacher') ...[
        _getStudentsAndClasses(),
        _getTeacherName(),
        _getSubjects(),
        _getWeeklyTeacherSchedule(),
      ],
      if (userStatus == 'student') ...[
        _getHomework(),
        _getAttendance(),
        _getAttendancePerc(),
        _getGrades(),
        _getAttendanceCount(),
        _getAllGrades(),
        _getEvents(),
        _getWeeklySchedule(),
      ],
    ]);

    var counts = await Accounting.getTotalOperationCounts();
    print('Total database reads: $counts');

    // Update the loading state after data has been fetched
    if (mounted) {
      setState(() {
        isDataLoading = false;
        if (!isDataLoading) {
          isLoading = true;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Fetch the school ID first
    _getSchoolId().then((_) {
      if (schoolId.isNotEmpty) {
        // After fetching the school ID, proceed with calling the process logs function and loading data
        cloudFunctions.getLogs(schoolId);
        _loadData().then((_) {
          if (mounted) {
            setState(() {
              if (!isDataLoading) {
                isLoading = false;
              }
            });
          }
        });
      } else {
        // Handle the case where schoolId is not available or empty
        print("School ID is not available.");
        // You can set an error state or handle it according to your app's logic
      }
    });
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
        userStatus: userStatus,
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
              child: Builder(
                builder: (context) {
                  switch (userStatus) {
                    case 'teacher':
                      return ContentColumn(
                        children: [
                          WeeklySchedule(
                            schedule: teachSchedule,
                            userStatus: userStatus,
                          ),
                          const History(),
                          // Add any other teacher-specific widgets here
                        ],
                      );

                    case 'student':
                      return ContentColumn(
                        children: [
                          WeeklySchedule(
                            schedule: schedule,
                            userStatus: userStatus,
                          ),
                          RecentGrades(grades: grades, allGrades: allGrades),
                          RecentHomework(homework: homework),
                          Events(events: events),
                          Attendace(
                            attendance: attendance,
                            attendanceCount: attendanceCount,
                            absencePercentageMap: absencePercentageMap,
                          ),
                          // Add any other student-specific widgets here
                        ],
                      );

                    case 'owner':
                      return ContentColumn(
                        children: [
                          // Add owner-specific widgets here, or an empty container if not needed
                          Container(),
                        ],
                      );

                    default:
                      return const Center(
                        child: Text('Unknown user status'),
                      );
                  }
                },
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
                    MaterialPageRoute(
                        builder: (context) => HwCreatingPage(
                            classes: classes,
                            subjects: subjects,
                            teacherName: teacherName)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.border_color_rounded),
                title: const Text('Give a grade'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GradeCreatingPage(
                            students: students,
                            subjects: subjects,
                            teacherName: teacherName)),
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
            ],
          );
        });
  }
}
