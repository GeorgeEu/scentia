import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class ExamsModel {
  final FirestoreData data = FirestoreData();
  Future<List<Map<String, dynamic>>> fetchExams() async {
    String? userId = AuthService.getCurrentUserId();
    List<DocumentSnapshot> exams = await data.getExams(userId!);
    List<Map<String, dynamic>> tempExamItems = [];
    for (var exam in exams) {
      var examData = exam.data() as Map<String, dynamic>;
      DocumentSnapshot assistantDoc = await data.getDoc(examData['assistant']);
      String assistantName = assistantDoc['name'];

      DocumentSnapshot subjectDoc = await data.getDoc(examData['name']);
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      DateTime date = (examData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MM-dd – kk:mm').format(date);

      tempExamItems.add({
        'assistant': assistantName,
        'date': formattedDate,
        'name': subjectName,
        'room': examData['room'],
        'desc': examData['desc'],
      });
    }
    return tempExamItems;
  }
}