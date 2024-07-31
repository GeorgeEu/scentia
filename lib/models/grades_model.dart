import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class GradesModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchGrades() async {
    String? userId = AuthService.getCurrentUserId();
    List<DocumentSnapshot> grades = await data.getGrades(userId!);
    List<Future<Map<String, dynamic>>> gradeFutures = grades.map((grade) async {
      var gradeData = grade.data() as Map<String, dynamic>;

      Future<DocumentSnapshot> teacherDocFuture = data.getDoc(gradeData['teacher']);
      Future<DocumentSnapshot> subjectDocFuture = data.getDoc(gradeData['sid']);

      DocumentSnapshot subjectDoc = await subjectDocFuture;
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];


      DocumentSnapshot teacherDoc = await teacherDocFuture;
      DocumentReference nestedTeacherRef = teacherDoc['teacher'] as DocumentReference;
      DocumentSnapshot nestedTeacherDoc = await nestedTeacherRef.get();
      String teacherName = nestedTeacherDoc['name'];

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
    Map<String, Map<String, dynamic>> groupedGrades = {};

    // Create a list of futures to resolve all necessary data
    List<Future<void>> futures = grades.map((grade) async {
      var gradeData = grade.data() as Map<String, dynamic>;

      // Fetch the subject and teacher documents concurrently
      Future<DocumentSnapshot> subjectDocFuture = data.getDoc(gradeData['sid']);
      Future<DocumentSnapshot> teacherDocFuture = data.getDoc(gradeData['teacher']);

      DocumentSnapshot subjectDoc = await subjectDocFuture;
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      DocumentSnapshot teacherDoc = await teacherDocFuture;
      DocumentReference nestedTeacherRef = teacherDoc['teacher'] as DocumentReference;
      DocumentSnapshot nestedTeacherDoc = await nestedTeacherRef.get();
      String teacherName = nestedTeacherDoc['name'];

      DateTime date = (gradeData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);

      Map<String, dynamic> gradeInfo = {
        'grade': gradeData['grade'],
        'date': formattedDate,
      };

      // Group grades by subject name
      if (groupedGrades.containsKey(subjectName)) {
        groupedGrades[subjectName]!['Grades'].add(gradeInfo);
      } else {
        groupedGrades[subjectName] = {
          'subjectName': subjectName,
          'teacher': teacherName,
          'Grades': [gradeInfo],
        };
      }
    }).toList();

    // Wait for all futures to complete
    await Future.wait(futures);

    // Calculate mean grades
    for (var entry in groupedGrades.values) {
      List<Map<String, dynamic>> gradesList = entry['Grades'];
      double meanGrade = gradesList
          .map((grade) => grade['grade'] as int)
          .reduce((a, b) => a + b) /
          gradesList.length;
      entry['meanGrade'] = meanGrade;
    }

    return groupedGrades.values.toList();
  }









}
