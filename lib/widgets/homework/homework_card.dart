import 'package:flutter/material.dart';

import 'homework_segment.dart';

class HomeworkCard extends StatefulWidget {
  final List _homework;

  const HomeworkCard(this._homework);

  @override
  State<HomeworkCard> createState() => _HomeworkCardState();
}

class _HomeworkCardState extends State<HomeworkCard> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._homework.length; //fix it later
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: homeworkCount,
      itemBuilder: (context, day) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 8, top: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.grey.shade50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget._homework[day]['day'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),
                (widget._homework[day]['homework'].length > 0)
                    ? ListView.separated(
                        padding: EdgeInsets.only(bottom: 8),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: widget._homework[day]['homework'].length,
                        itemBuilder: (context, index) {
                          return HomeworkSegment(
                              widget._homework[day]['homework'][index]);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            thickness: 0.5,
                            height: 6,
                          );
                        },
                      )
                    : Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: const Text(
                        'There is no homework',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
