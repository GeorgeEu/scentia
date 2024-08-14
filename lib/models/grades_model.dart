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

    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
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

    List<Map<String, dynamic>> gradeDataList = [];
    for (var grade in grades) {
      var gradeData = grade.data() as Map<String, dynamic>;

      DocumentSnapshot subjectDoc = await data.getDoc(gradeData['sid']);
      String subjectName = subjectDoc['name'];

      DateTime date = (gradeData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);

      gradeDataList.add({
        'grade': gradeData['grade'],
        'subject': subjectName,
        'teacher': gradeData['teacher'],
        'date': formattedDate,
      });
    }

    return gradeDataList;
  }

  Future<List<Map<String, dynamic>>> getSubjectGrades() async {
    String? userId = AuthService.getCurrentUserId();

    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    List<DocumentSnapshot> grades = await data.getGrades(userDocRef);
    Map<String, Map<String, dynamic>> groupedGrades = {};

    for (var grade in grades) {
      var gradeData = grade.data() as Map<String, dynamic>;

      DocumentSnapshot subjectDoc = await data.getDoc(gradeData['sid']);
      String subjectName = subjectDoc['name'];

      DateTime date = (gradeData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);

      Map<String, dynamic> gradeInfo = {
        'grade': gradeData['grade'],
        'date': formattedDate,
      };

      if (groupedGrades.containsKey(subjectName)) {
        groupedGrades[subjectName]!['Grades'].add(gradeInfo);
      } else {
        groupedGrades[subjectName] = {
          'subjectName': subjectName,
          'teacher': gradeData['teacher'],
          'Grades': [gradeInfo],
        };
      }
    }

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
