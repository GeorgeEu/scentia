import 'package:flutter/material.dart';
import 'package:scientia/widgets/attendance/attendance_list.dart';

class AttendancePage extends StatefulWidget {
  final List<Map<String, dynamic>> attendance;
  const AttendancePage({super.key, required this.attendance});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF3F2F8),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Color(0xFFA4A4FF),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Attendance',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
        ),
      body: AttendanceList(attendance: widget.attendance)
    );
  }
}
