import 'package:flutter/material.dart';
import 'package:scientia/views/homework_page.dart';
import 'package:scientia/models/homework_model.dart';

import 'homework_test.dart';

class RecentHomework extends StatefulWidget {
  const RecentHomework({super.key});

  @override
  State<RecentHomework> createState() => _RecentHomeworkState();
}

class _RecentHomeworkState extends State<RecentHomework> {
  List<Map<String, dynamic>> _homework = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHomework();
  }

  void _fetchHomework() async {
    List<Map<String, dynamic>> homework = await HomeworkModel().fetchHomework();
    if (mounted) {
      setState(() {
        _homework = homework;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int extraHomeworkCount = _homework.length > 2 ? _homework.length - 2 : 0;

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
              if (!_isLoading && extraHomeworkCount > 0)
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeworkPage()
                    ));
                  },
                  child: Text(
                    '+$extraHomeworkCount more',
                    style: const TextStyle(
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
