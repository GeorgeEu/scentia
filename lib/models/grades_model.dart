import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';
import '../services/subject_services.dart';

class GradesModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchGrades() async {
    String? userId = AuthService.getCurrentUserId();
    List<DocumentSnapshot> grades = await data.getGrades(userId!);
    List<Future<Map<String, dynamic>>> gradeFutures = grades.map((grade) async {
      var gradeData = grade.data() as Map<String, dynamic>;

      Future<DocumentSnapshot> teacherDocFuture = data.getDoc(gradeData['teacher']);
      Future<DocumentSnapshot> subjectDocFuture = data.getDoc(gradeData['sid']);

      DocumentSnapshot teacherDoc = await teacherDocFuture;
      String teacherName = teacherDoc['name'];

      DocumentSnapshot subjectDoc = await subjectDocFuture;
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      DateTime date = (gradeData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);

      return {
        'grade': gradeData['grade'],
        'subject': subjectName,
        'teacher': teacherName,
        'date': formattedDate,
      };
    }).toList();

    return await Future.wait(gradeFutures);
  }


  Future<List<Map<String, dynamic>>> getSubjectGrades() async {
    String? userId = AuthService.getCurrentUserId();
    List<DocumentSnapshot> grades = await data.getGrades(userId!);
    var subjectsSet = <DocumentReference>{};
    grades.forEach((grade) {
      var data = grade.data() as Map<String, dynamic>;
      subjectsSet.add(data['sid']);
    });

    List<Map<String, dynamic>> allSubjectGrades = [];
    for (var subjectRef in subjectsSet) {
      // Fetch the nested subject document
      DocumentSnapshot subjectDoc = await data.getDoc(subjectRef);
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

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
