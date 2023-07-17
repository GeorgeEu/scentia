import 'package:flutter/material.dart';

class Homework extends StatefulWidget {
  final List _homework;

  const Homework(this._homework);

  @override
  State<Homework> createState() => _HomeworkState();
}

class _HomeworkState extends State<Homework> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._homework.length;
    return Column(
      children: [

      ],
    );
    // Container(
    //   height: homeworkCount * 80,
    //   padding: const EdgeInsets.only(top: 8),
    //   child: ListView.separated(
    //     primary: false,
    //     shrinkWrap: true,
    //     itemCount: homeworkCount,
    //     itemBuilder: (context, index) {
    //       return HomeworkSegment(widget._homework[index]);
    //     },
    //     separatorBuilder: (context, index) {
    //       return const Divider(
    //           thickness: 0.5,
    //       );
    //     },
    //   ),
    // ),
  }
}