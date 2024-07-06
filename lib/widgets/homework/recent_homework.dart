import 'package:flutter/material.dart';
import 'package:scientia/views/homework_page.dart';

import 'homework_test.dart';

class RecentHomework extends StatefulWidget {
  const RecentHomework({super.key});

  @override
  State<RecentHomework> createState() => _RecentHomeworkState();
}

class _RecentHomeworkState extends State<RecentHomework> {
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
                'Homework',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const Spacer(),
              TextButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeworkPage()
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
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: HomeworkTest(),
          )
        ],
      ),
    );
  }
}