import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/services/subject_services.dart';
import 'package:scientia/utils/formater.dart';

import '../../services/auth_services.dart'; // Import the color utilities

class LessonGrades extends StatefulWidget {
  final FirestoreData data = FirestoreData();

  LessonGrades({super.key});

  @override
  State<LessonGrades> createState() => _LessonGradesState();
}

class _LessonGradesState extends State<LessonGrades> {
  SubjectServices subjects = SubjectServices();

  @override
  void initState() {
    super.initState();
    subjects.initialize();
  }

  Future<List<Map<String, dynamic>>> getSubjectGrades() async {
    String? userId = AuthService.getCurrentUserId();
    List<DocumentSnapshot> grades = await widget.data.getGrades(userId!);
    var subjectsSet = Set<String>();
    grades.forEach((grade) {
      var data = grade.data() as Map<String, dynamic>;
      subjectsSet.add(data['sid']);
    });

    List<Map<String, dynamic>> allSubjectGrades = [];
    for (var subject in subjectsSet) {
      String subjectName = await subjects.getSubjectById(subject);
      List<Map<String, dynamic>> subjectGrades = grades.where((grade) {
        var data = grade.data() as Map<String, dynamic>;
        return data['sid'] == subject;
      }).map((grade) => grade.data() as Map<String, dynamic>).toList();

      // Calculate the mean grade
      double meanGrade = subjectGrades
          .map((grade) => grade['grade'] as int)
          .reduce((a, b) => a + b) /
          subjectGrades.length;

      allSubjectGrades.add({
        "SID": subject,
        "subjectName": subjectName,
        "Grades": subjectGrades,
        "meanGrade": meanGrade,
      });
    }
    return allSubjectGrades;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getSubjectGrades(),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No grades available'));
        }

        List<Map<String, dynamic>> allGrades = snapshot.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, bottom: 16),
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: allGrades.length,
              itemBuilder: (context, index) {
                var subjectGradesMap = allGrades[index];
                List<Map<String, dynamic>> grades = subjectGradesMap['Grades'];
                double meanGrade = subjectGradesMap['meanGrade'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          subjectGradesMap['subjectName'],
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            meanGrade.toStringAsFixed(2),
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: grades.map<Widget>((grade) {
                          final gradeValue = grade['grade'];
                          final colorOrGradient = Formater.gradeToColor(gradeValue); // Using the utility function
                          return Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: colorOrGradient is Color ? colorOrGradient : null,
                              gradient: colorOrGradient is LinearGradient ? colorOrGradient : null,
                            ),
                            child: Text(
                              gradeValue.toString(),
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Divider(thickness: 0.5),
            ),
          ),
        );
      },
    );
  }
}
