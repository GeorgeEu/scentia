import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class ExamsModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchExams() async {
    String? userId = AuthService.getCurrentUserId();

    // Get the user's document reference
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    List<DocumentSnapshot> exams = await data.getExams(userDocRef);

    // Use Future.wait to fetch all data concurrently
    List<Future<Map<String, dynamic>>> examFutures = exams.map((exam) async {
      var examData = exam.data() as Map<String, dynamic>;

      // Fetch assistant and subject documents concurrently
      Future<DocumentSnapshot> assistantDocFuture = data.getDoc(examData['assistant']);
      Future<DocumentSnapshot> subjectDocFuture = data.getDoc(examData['name']);

      DocumentSnapshot assistantDoc = await assistantDocFuture;
      String assistantName = assistantDoc['name'];

      DocumentSnapshot subjectDoc = await subjectDocFuture;
      String subjectName = subjectDoc['name'];

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
