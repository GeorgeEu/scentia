import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'firestore_data.dart';
import 'subject_services.dart';

class GradeServices {
  final FirestoreData data = FirestoreData();
  var subjects = SubjectServices();

  void Grades() async {
    List<DocumentSnapshot> grades =
    await data.getGrades('Tb3HelcRbnQZcxHok9l4YI5pwwI3');
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
  }
}