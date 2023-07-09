import 'package:card_test/components/home_work/full_hw/lesson_home_work.dart';
import 'package:flutter/material.dart';

class HomeWork extends StatefulWidget {
  final List _tasks;
  const HomeWork(this._tasks);

  @override
  State<HomeWork> createState() => _HomeWorkState();
}

class _HomeWorkState extends State<HomeWork> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._tasks.length;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Container(
        height: homeworkCount * 68,
        padding: const EdgeInsets.only(top: 8),
        child: ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: homeworkCount,
          itemBuilder: (context, index) {
            return LessonHW(widget._tasks[index]);
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 0.5,
            );
          },
        ),
      ),
    );
  }
}
