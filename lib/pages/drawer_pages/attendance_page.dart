import 'package:scientia/components/attendance/full_absence_segment.dart';
import 'package:scientia/components/attendance/full_attendance.dart';
import 'package:scientia/data/attendance_data/attendance_data.dart';
import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    final attendance = AttendanceData();
    final semesterAttendance = attendance.getSemesterAttendance();
    // print(monthlyAttendance);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Attendance',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {Navigator.pop(context);}
        ),
      ),
      body: Container(
        color: const Color(0xffefeff4),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FullAttendance(semesterAttendance)
            ],
          ),
        ),
      )
    );
  }
}

