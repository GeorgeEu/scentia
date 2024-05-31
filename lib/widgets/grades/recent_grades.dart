import 'package:flutter/material.dart';
import 'package:scientia/views/grades_page.dart';
import 'package:scientia/widgets/grades/daily_grades_test.dart';

class RecentGrades extends StatefulWidget {
  const RecentGrades({super.key});

  @override
  State<RecentGrades> createState() => _RecentGradesState();
}

class _RecentGradesState extends State<RecentGrades> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Grades',
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
                      builder: (context) => const GradesPage()
                  ));
                },
                child: const Text(
                  'Show All',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: DailyGradesTest(),
          )
        ],
      ),
    );
  }
}
