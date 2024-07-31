import 'package:flutter/material.dart';
import 'package:scientia/views/grades_page.dart';
import 'package:scientia/widgets/grades/daily_grades_test.dart';

import '../st_chevron_right.dart';
import '../st_header.dart';
import '../st_row.dart';

class RecentGrades extends StatefulWidget {
  final List<Map<String, dynamic>> grades;
  final List<Map<String, dynamic>> allGrades;
  const RecentGrades({super.key, required this.grades, required this.allGrades});

  @override
  State<RecentGrades> createState() => _RecentGradesState();
}

class _RecentGradesState extends State<RecentGrades> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StRow(
          stHeader: StHeader(text: 'Grades'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GradesPage(allGrades: widget.allGrades))
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => GradesPage(allGrades: widget.allGrades))
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            padding: const EdgeInsets.only(top: 14, bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: DailyGradesTest(gradeItems: widget.grades),
          ),
        )
      ],
    );
  }
}
