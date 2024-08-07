import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class GradesModel {
  final FirestoreData data = FirestoreData();

  Future<String> getUserStatus() async {
    String? userId = AuthService.getCurrentUserId();

    if (userId == null) {
      return 'student'; // or handle the null case appropriately
    }

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userDocRef.get();

    // Ensure data is not null and cast to Map<String, dynamic>
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    // Return the status or default to 'student'
    return userData?['status'] ?? 'student';
  }


  Future<List<Map<String, dynamic>>> fetchGrades() async {
    String userStatus = await getUserStatus();

    if (userStatus != 'student') {
      return []; // Return an empty list or handle non-student case
    }

    String? userId = AuthService.getCurrentUserId();
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    List<DocumentSnapshot> grades = await data.getGrades(userDocRef);
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

    // Get the user's document reference
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    List<DocumentSnapshot> grades = await data.getGrades(userDocRef);
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
