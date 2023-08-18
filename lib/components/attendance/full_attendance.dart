import 'package:scientia/components/attendance/full_attendance_card.dart';
import 'package:flutter/material.dart';

import 'full_absence_segment.dart';



class FullAttendance extends StatefulWidget {
  final List _attendance;

  const FullAttendance(this._attendance);

  @override
  State<FullAttendance> createState() => _FullAttendanceState();
}

class _FullAttendanceState extends State<FullAttendance> {
  @override
  Widget build(BuildContext context) {
    var attendanceCount = widget._attendance.length; //fix it later
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Column(
        children: [
          FullAttendanceCard(widget._attendance)
        ],
      ),
    );
  }
}
