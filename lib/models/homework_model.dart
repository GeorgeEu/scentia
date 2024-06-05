import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';

class HomeworkModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchHomework() async {
    DocumentReference user = FirebaseFirestore.instance
        .collection('users')
        .doc('Tb3HelcRbnQZcxHok9l4YI5pwwI3');

    List<DocumentSnapshot> homework = await data.getHomework(user);
    List<Map<String, dynamic>> tempHomework = [];
    for (var task in homework) {
      var homeworkData = task.data() as Map<String, dynamic>;
      DocumentSnapshot subjectDoc = await data.getDoc(task['subject']);
      DocumentSnapshot teacherDoc = await data.getDoc(task['teacher']);
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
