import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';
import '../services/auth_services.dart';

class HomeworkModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchHomework() async {
    String? userId = AuthService.getCurrentUserId();

    // Get the user's document reference
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Fetch the homework documents for the current user
    List<DocumentSnapshot> homeworkDocs = await data.getHomework(userDocRef);
    List<Future<Map<String, dynamic>>> homeworkFutures = homeworkDocs.map((task) async {
      var homeworkData = task.data() as Map<String, dynamic>;

      Future<DocumentSnapshot> subjectDocFuture = data.getDoc(homeworkData['subject']);
      Future<DocumentSnapshot> teacherDocFuture = data.getDoc(homeworkData['teacher']);

      DocumentSnapshot subjectDoc = await subjectDocFuture;
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      DocumentSnapshot teacherDoc = await teacherDocFuture;
      DocumentReference nestedTeacherRef = teacherDoc['teacher'] as DocumentReference;
      DocumentSnapshot nestedTeacherDoc = await nestedTeacherRef.get();
      String teacherName = nestedTeacherDoc['name'];

      DateTime date = (homeworkData['endAt'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);

      return {
        'task': homeworkData['task'],
        'subject': subjectName,
        'teacher': teacherName,
        'date': formattedDate,
      };
    }).toList();

    return await Future.wait(homeworkFutures);
  }
}

