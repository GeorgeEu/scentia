import 'package:scientia/widgets/attendance/summary_attendance/absence_summary_segment.dart';
import 'package:scientia/widgets/attendance/summary_attendance/late_summary_segment.dart';
import 'package:scientia/widgets/attendance/attendance_calendar.dart';
import 'package:flutter/material.dart';

class Attendace extends StatelessWidget {
  final Map<String, dynamic> _attendance;

  const Attendace(this._attendance);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 62),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Attendance',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const Spacer(),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AttendanceCalendar()
                    ));
                  },
                  child: Text(
                    'Show More',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
            ],
          ),
          Row(
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
        ],
      ),
    );

  }
}
