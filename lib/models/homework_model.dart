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
    List<Map<String, dynamic>> tempHomework = [];

    for (var task in homeworkDocs) {
      var homeworkData = task.data() as Map<String, dynamic>;
      DocumentSnapshot subjectDoc = await data.getDoc(homeworkData['subject']);
      DocumentSnapshot teacherDoc = await data.getDoc(homeworkData['teacher']);
      String subjectName = subjectDoc['name']; // Adjust this field based on your Firestore structure
      String teacherName = teacherDoc['name']; // Adjust this field based on your Firestore structure
      DateTime date = (homeworkData['endAt'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);
      tempHomework.add({
        'task': homeworkData['task'],
        'subject': subjectName,
        'teacher': teacherName,
        'date': formattedDate,
      });
    }

    return tempHomework; // Return the fetched homework items
  }
}
