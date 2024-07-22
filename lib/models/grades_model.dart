import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';
import '../services/subject_services.dart';

class GradesModel {
  //final SubjectServices subjects = SubjectServices();
  final FirestoreData data = FirestoreData();

  // void initialize() {
  //   subjects.initialize();
  // }

  Future<List<Map<String, dynamic>>> fetchGrades() async {
    String? userId = AuthService.getCurrentUserId();
    List<DocumentSnapshot> grades = await data.getGrades(userId!);
    List<Map<String, dynamic>> tempGradeItems = [];
    for (var grade in grades) {
      var gradeData = grade.data() as Map<String, dynamic>;
      DocumentSnapshot teacherDoc = await data.getDoc(gradeData['teacher']);
      DocumentSnapshot subjectDoc = await data.getDoc(gradeData['sid']);
      String teacherName = teacherDoc['name'];
      String subjectName = subjectDoc['name'];
      //String subjectName = await subjects.getSubjectById(gradeData['sid']);
      DateTime date = (gradeData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);
      tempGradeItems.add({
        'grade': gradeData['grade'],
        'subject': subjectName,
        'teacher': teacherName,
        'date': formattedDate,
      });
    }
    return tempGradeItems;
  }

  Future<List<Map<String, dynamic>>> getSubjectGrades() async {
    String? userId = AuthService.getCurrentUserId();
    List<DocumentSnapshot> grades = await data.getGrades(userId!);
    var subjectsSet = Set<DocumentReference>();
    grades.forEach((grade) {
      var data = grade.data() as Map<String, dynamic>;
      subjectsSet.add(data['sid']);
    });

    List<Map<String, dynamic>> allSubjectGrades = [];
    for (var subjectRef in subjectsSet) {
      // Fetch subject name from Firestore using the reference
      DocumentSnapshot subjectDoc = await data.getDoc(subjectRef);
      String subjectName = subjectDoc['name'];

      // Filter grades for the current subject
      List<Map<String, dynamic>> subjectGrades = [];
      for (var grade in grades) {
        var gradeData = grade.data() as Map<String, dynamic>;
        if (gradeData['sid'] == subjectRef) {
          DocumentSnapshot teacherDoc = await data.getDoc(gradeData['teacher']);
          String teacherName = teacherDoc['name'];
          DateTime date = (gradeData['date'] as Timestamp).toDate();
          String formattedDate = DateFormat('MMM d').format(date);
          subjectGrades.add({
            'grade': gradeData['grade'],
            'teacher': teacherName,
            'date': formattedDate,
          });
        }
      }

      // Calculate the mean grade
      double meanGrade = subjectGrades
          .map((grade) => grade['grade'] as int)
          .reduce((a, b) => a + b) /
          subjectGrades.length;

      allSubjectGrades.add({
        "SID": subjectRef.id,
        "subjectName": subjectName,
        "Grades": subjectGrades,
        "meanGrade": meanGrade,
      });
    }
    return allSubjectGrades;
  }

}
