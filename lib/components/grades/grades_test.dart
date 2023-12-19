import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scientia/data/firestore_data.dart';


class GradesTest extends StatefulWidget {
  final data = FirestoreData();

  @override
  State<GradesTest> createState() => _GradesTestState();
}

class _GradesTestState extends State<GradesTest> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Grade>>(
      stream: widget.data.getDailyGrades(1702226792000),
        builder: (BuildContext context, AsyncSnapshot<List<Grade>?> gradesSnapshot) {
        if (gradesSnapshot.hasData) {
          return SizedBox(
            height: 100,
            child: ListView(
              children: gradesSnapshot.data!.map((Grade grade) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(grade.grade.toString()),
                      Text(grade.name.toString()),
                      Text(grade.date.toString())
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
