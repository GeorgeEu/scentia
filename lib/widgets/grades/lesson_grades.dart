import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/services/subject_services.dart';

class LessonGrades extends StatefulWidget {
  final FirestoreData data = FirestoreData();

  LessonGrades({super.key});

  @override
  State<LessonGrades> createState() => _LessonGradesState();
}

class _LessonGradesState extends State<LessonGrades> {
  SubjectServices subjects = SubjectServices();
  List<Map<String, dynamic>> gradeItems = [];
  List allGrades = [];

  @override
  void initState() {
    super.initState();
    subjects.initialize();
    getSubjectGrades();
  }

  void getSubjectGrades() async {
    List<DocumentSnapshot> grades = await widget.data.getGrades('Tb3HelcRbnQZcxHok9l4YI5pwwI3');
    var subjectsSet = Set<String>();
    grades.forEach((grade) {
      var data = grade.data() as Map<String, dynamic>;
      subjectsSet.add(data['sid']);
    });
    List allSubjectGrades = [];
    for (var subject in subjectsSet) {
      List<Map<String, dynamic>> subjectGrades = grades.where((grade) {
        var data = grade.data() as Map<String, dynamic>;
        return data['sid'] == subject;
      }).map((grade) => grade.data() as Map<String, dynamic>).toList();
      allSubjectGrades.add({
        "SID": subject,
        "Grades": subjectGrades,
      });
    }
    setState(() {
      allGrades = allSubjectGrades;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, bottom: 16),
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: allGrades.length,
        itemBuilder: (context, index) {
          var subjectGradesMap = allGrades[index];
          List<Map<String, dynamic>> grades = subjectGradesMap['Grades'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                // Use FutureBuilder to await the async getSubjectById method
                child: FutureBuilder<String>(
                  future: subjects.getSubjectById(subjectGradesMap['SID']),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Optionally, return a placeholder widget while waiting
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle errors, if any
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Display the fetched subject name
                      return Text(
                        snapshot.data!,
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      );
                    }
                  },
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: grades.map<Widget>((grade) => Container(
                  alignment: Alignment.center,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black12,
                  ),
                  child: Text(
                    grade['grade'].toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                )).toList(),
              )
            ],
          );
        },
        separatorBuilder: (context, index) => Divider(thickness: 0.5),
      ),
    );
  }
}
