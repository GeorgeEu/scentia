import 'package:flutter/material.dart';
import 'package:scientia/widgets/empty_state_page.dart';

class AttendanceList extends StatelessWidget {
  final List<Map<String, dynamic>> attendance;

  AttendanceList({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return attendance.isNotEmpty
        ? SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 11, left: 16, bottom: 16),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: attendance.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        attendance[index]['subject'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal, height: 1),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${attendance[index]['date']} – ',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey, height: 1),
                        ),
                        Text(
                          '${attendance[index]['start']} - ${attendance[index]['end']}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey, height: 1),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    attendance[index]['status'].toString(),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 16,
              thickness: 0.5,
            ); // This is the separator widget
          },
        ),
      ),
    )
        : Center(
      child: EmptyStatePage(
        message: "You weren't late or didn't miss class"
      ),
    );
  }
}
