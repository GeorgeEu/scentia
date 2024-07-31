import 'package:flutter/material.dart';
import 'package:scientia/views/attendance_page.dart';
import '../st_chevron_right.dart';
import '../st_header.dart';
import '../st_row.dart';

class Attendace extends StatelessWidget {
  final List<Map<String, dynamic>> attendance;
  final Map<String, int> attendanceCount;

  const Attendace({super.key, required this.attendance, required this.attendanceCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StRow(
          stHeader: StHeader(text: 'Attendance'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AttendancePage(attendance: attendance))
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AttendancePage(attendance: attendance))
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black12,
                              child: Icon(
                                Icons.access_time,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Lates',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  height: 1,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                attendanceCount['Late'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black12,
                              child: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Absences',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  height: 1,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                attendanceCount['Absence'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  height: 1,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
