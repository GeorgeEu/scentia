import 'package:card_test/components/home_work/homework/homework_segment.dart';
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
        Padding(
          padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
          child: Container(
            padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Text(
              "Monday",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 21
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
          child: Container(
            padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Text(
              "Tuesday",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
          child: Container(
            padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Text(
              "Wednesday",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
          child: Container(
            padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Text(
              "Thursday",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
          child: Container(
            padding: EdgeInsets.only(left: 16,right: 16,top: 8, bottom: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)
            ),
            child: Text(
              "Friday",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21
              ),
            ),
          ),
        ),
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