import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/data/firestore_data.dart';

class DailyGradesTest extends StatefulWidget {
  final data = FirestoreData();

  DailyGradesTest({super.key});

  @override
  State<DailyGradesTest> createState() => _DailyGradesTestState();
}

class Subjects {
  final FirestoreData data = FirestoreData();
  static List<Map<String, dynamic>> subjects =
      []; // Initialize as an empty list
  void initialize() async {
    List<DocumentSnapshot> docs = await data.getSubjects();
    for (var doc in docs) {
      Map<String, dynamic> subject = doc.data() as Map<String, dynamic>;
      subject['id'] = doc.id;
      subjects.add(subject); // No need for null check
    }
  }

  String getSubjectById(String id) {
    try {
      var subject = subjects.firstWhere((subject) => subject['id'] == id);
      return subject['name']; // Assuming 'name' is always a String
    } catch (e) {
      // Handle the case where no match is found or any other exception
      return 'No subject found with id $id';
    }
  }

// Other functions...
}

class _DailyGradesTestState extends State<DailyGradesTest> {
  Subjects subjects = Subjects();
  List<Map<String, dynamic>> gradeItems = []; // A list to store grade details

  @override
  void initState() {
    super.initState();
    subjects.initialize();
    Grades();
  }

  void Grades() async {
    List<DocumentSnapshot> grades =
        await widget.data.getGrades('Tb3HelcRbnQZcxHok9l4YI5pwwI3');
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
        'date': formattedDate
      });
    }
    setState(() {
      gradeItems = tempGradeItems; // Update the state with the new data
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
                    child: Text(
                      gradeItems[index]['grade'].toString(),
                      style: TextStyle(
                          fontSize: 16
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
