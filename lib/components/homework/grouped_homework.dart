import 'package:card_test/components/homework/homework_segment.dart';
import 'package:flutter/material.dart';

class GroupedHomework extends StatefulWidget {
  final Map<String, dynamic> _groupedHomework;

  GroupedHomework(this._groupedHomework, Map<String, dynamic> groupData);

  @override
  State<GroupedHomework> createState() => _GroupedHomeworkState();
}

class _GroupedHomeworkState extends State<GroupedHomework> {
  get homeworkCount => widget._groupedHomework.length;

  String formatDate(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16)
      ),
      height: homeworkCount * 80,
      padding: const EdgeInsets.only(top: 8),
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: homeworkCount,
        itemBuilder: (context, index) {
          return HomeworkSegment(widget._groupedHomework[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 0.5,
          );
        },
      ),
    );
    // Text(
    //   formatDate(widget._homework['Date']),
    //   style: TextStyle(
    //     fontWeight: FontWeight.w600,
    //     fontSize: 22,
    //   ),
    // ),
    // Row(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(right: 8),
    //       child: Text(
    //           widget._homework['Name'].toString(),
    //           style: const TextStyle(
    //               fontWeight: FontWeight.w500,
    //               fontSize: 16,
    //               color: Colors.grey)),
    //     ),
    //     Expanded(
    //       child: Text(
    //         widget._homework['Task'].toString(),
    //         overflow: TextOverflow.ellipsis,
    //         style: const TextStyle(fontSize: 23),
    //       ),
    //     ),
    //   ],
    // )
  }
}
