import 'package:scientia/widgets/attendance/summary_attendance/absence_summary_segment.dart';
import 'package:scientia/widgets/attendance/summary_attendance/late_summary_segment.dart';
import 'package:scientia/widgets/attendance/attendance_calendar.dart';
import 'package:flutter/material.dart';

import '../../st_chevron_right.dart';
import '../../st_header.dart';
import '../../st_row.dart';

class Attendace extends StatelessWidget {
  final Map<String, dynamic> _attendance;

  const Attendace(this._attendance);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StRow(
          stHeader: StHeader(text: 'Attendance'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AttendanceCalendar())
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AttendanceCalendar())
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: AbsenceSummarySegment(_attendance),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: LateSummarySegment(_attendance),
                ),
              ),
            ],
          ),
        ),
      ],
    );

  }
}
