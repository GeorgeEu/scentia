import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class ExamsModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchExams() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      return [];
    }
    List<DocumentSnapshot> exams = await data.getExams(userId);

    // Use Future.wait to fetch all data concurrently
    List<Future<Map<String, dynamic>>> examFutures = exams.map((exam) async {
      var examData = exam.data() as Map<String, dynamic>;

      // Fetch assistant and subject documents concurrently
      Future<DocumentSnapshot> assistantDocFuture = data.getDoc(examData['assistant']);
      Future<DocumentSnapshot> subjectDocFuture = data.getDoc(examData['name']);

      DocumentSnapshot assistantDoc = await assistantDocFuture;
      String assistantName = assistantDoc['name'];

      DocumentSnapshot subjectDoc = await subjectDocFuture;
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      DateTime date = (examData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MM-dd – kk:mm').format(date);

      return {
        'assistant': assistantName,
        'date': formattedDate,
        'name': subjectName,
        'room': examData['room'],
        'desc': examData['desc'],
      };
    }).toList();

    // Await all futures to complete
    return await Future.wait(examFutures);
  }
}
