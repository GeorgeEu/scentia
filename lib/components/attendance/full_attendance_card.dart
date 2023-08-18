import 'package:scientia/components/attendance/full_absence_segment.dart';
import 'package:flutter/material.dart';

class FullAttendanceCard extends StatelessWidget {
  final List _attendance;

  FullAttendanceCard(this._attendance);

  @override
  Widget build(BuildContext context) {
    // print(_attendance);
    var attendanceCount = _attendance.length;
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: attendanceCount,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
        height: 1,
        thickness: 0.5,
      ),
      itemBuilder: (context, month) {
        return Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _attendance[month]['month'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),
                FullAbsenceSegment(_attendance[month]),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chevron_right_rounded,
                size: 28,
              ),
              color: Colors.grey,
            ),
          ],
        );
      },
    );
  }
}
