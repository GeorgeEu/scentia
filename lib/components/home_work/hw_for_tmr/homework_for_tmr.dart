import 'package:card_test/components/home_work/full_hw/lesson_home_work.dart';
import 'package:card_test/components/home_work/hw_for_tmr/tmr_lesson_hw.dart';
import 'package:flutter/material.dart';

class TmrHomeWork extends StatefulWidget {
  final List _tmr_tasks;
  const TmrHomeWork(this._tmr_tasks);

  @override
  State<TmrHomeWork> createState() => _TmrHomeWorkState();
}

class _TmrHomeWorkState extends State<TmrHomeWork> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._tmr_tasks.length;
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
      child: Container(
        height: homeworkCount * 68,
        padding: const EdgeInsets.only(top: 8),
        child: ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: homeworkCount,
          itemBuilder: (context, index) {
            return TmrLessonHW(widget._tmr_tasks[index]);
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