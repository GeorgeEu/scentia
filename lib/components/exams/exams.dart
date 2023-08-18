import 'package:flutter/material.dart';

import 'exams_segment.dart';

class Exams extends StatelessWidget {
  final List _exams;

  Exams(this._exams);

  @override
  Widget build(BuildContext context) {
    var examsCount = _exams.length;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Column(
        children: [
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: examsCount,
            itemBuilder: (context, index) {
              return ExamsSegment(_exams[index]);
            },
          ),
        ],
      ),
    );
  }
}
