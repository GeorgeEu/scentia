import 'package:flutter/material.dart';

class LessonGradesSegment extends StatelessWidget {
  final List<dynamic> _grades;

  const LessonGradesSegment(this._grades);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _grades[0]['Lesson'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22
                  ),
                ),
              ),
              // The Expanded widget is inside the Column
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var grades in _grades[0]['Grades'])
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black12,
                      ),
                      child: Text(
                        grades['Grade'],
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
