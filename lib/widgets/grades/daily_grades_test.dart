import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';

import '../../services/subject_services.dart';

class DailyGradesTest extends StatefulWidget {
  final data = FirestoreData();

  DailyGradesTest({super.key});

  @override
  State<DailyGradesTest> createState() => _DailyGradesTestState();
}

class _DailyGradesTestState extends State<DailyGradesTest> {
  SubjectServices subjects = SubjectServices();
  List<Map<String, dynamic>> gradeItems = []; // A list to store grade details

  @override
  void initState() {
    super.initState();
    subjects.initialize();
    Grades();
  }

  void Grades() async {
    List<DocumentSnapshot> grades = await widget.data.getGrades('Tb3HelcRbnQZcxHok9l4YI5pwwI3');
    List<Map<String, dynamic>> tempGradeItems = [];
    for (var grade in grades) {
      var gradeData = grade.data() as Map<String, dynamic>;
      String subjectName = subjects.getSubjectById(gradeData['sid']);
      DateTime date = (gradeData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);
      tempGradeItems.add({
        'grade': gradeData['grade'],
        'subject': subjectName,
        'teacher': gradeData['teacher'],
        'date': formattedDate,
      });
    }
    setState(() {
      gradeItems = tempGradeItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, bottom: 16),
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: gradeItems.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      gradeItems[index]['subject'],
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      gradeItems[index]['date'],
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      gradeItems[index]['teacher'].toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, right: 16),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.grey.shade400
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        gradeItems[index]['grade'].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 0.5,
          ); // This is the separator widget
        },
      ),
    );
  }

}