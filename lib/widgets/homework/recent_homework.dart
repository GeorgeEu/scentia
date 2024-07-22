import 'package:flutter/material.dart';
import 'package:scientia/views/homework_page.dart';
import 'package:scientia/widgets/st_chevron_right.dart';
import 'package:scientia/widgets/st_header.dart';

import '../st_row.dart';
import 'homework_test.dart';

class RecentHomework extends StatefulWidget {
  final List<Map<String, dynamic>> homework;

  const RecentHomework({super.key, required this.homework});

  @override
  State<RecentHomework> createState() => _RecentHomeworkState();
}

class _RecentHomeworkState extends State<RecentHomework> {

  @override
  Widget build(BuildContext context) {
    //int extraHomeworkCount = widget.homework.length > 2 ? widget.homework.length - 2 : 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StRow(
          stHeader: StHeader(text: 'Homework'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeworkPage(homework: widget.homework))
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomeworkPage(homework: widget.homework))
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: HomeworkTest(homework: widget.homework),
          ),
        )
      ],
    );
  }
}
