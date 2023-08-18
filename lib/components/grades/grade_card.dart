import 'package:flutter/material.dart';

import '../homework/homework_segment.dart';
import 'grade_segment.dart';

class GradeCard extends StatefulWidget {
  final List _grades;

  const GradeCard(this._grades);

  @override
  State<GradeCard> createState() => _GradeCardState();
}

class _GradeCardState extends State<GradeCard> {
  @override
  Widget build(BuildContext context) {
    var homeworkCount = widget._grades.length; //fix it later
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
                borderRadius: BorderRadius.circular(16), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget._grades[day]['day'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                    ),
                  ),
                ),
                (widget._grades[day]['grades'].length > 0)
                    ? ListView.separated(
                        padding: EdgeInsets.only(bottom: 8),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: widget._grades[day]['grades'].length,
                        itemBuilder: (context, index) {
                          return GradeSegment(
                              widget._grades[day]['grades'][index]);
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
                          "There aren't any grades",
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
