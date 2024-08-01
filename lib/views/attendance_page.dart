import 'package:flutter/material.dart';
import 'package:scientia/widgets/attendance/attendance_list.dart';
import '../widgets/attendance/missed_lesson_list.dart';
import '../widgets/attendance/attendance_list.dart'; // Ensure this import is correct

class AttendancePage extends StatefulWidget {
  final List<Map<String, dynamic>> attendance;
  final Map<String, double> absencePercentageMap;

  const AttendancePage({super.key, required this.attendance, required this.absencePercentageMap});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFFF3F2F8),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Color(0xFFA4A4FF),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Attendance',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'History'),
              Tab(text: 'Missed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AttendanceList(attendance: widget.attendance),
            MissedLessonList(absencePercentageMap: widget.absencePercentageMap)
          ],
        ),
      ),
    );
  }
}
