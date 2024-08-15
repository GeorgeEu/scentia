import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';

import '../services/auth_services.dart';
import '../services/user_status_service.dart';

class HomeworkModel {
  final FirestoreData data = FirestoreData();
  final UserStatusService userService = UserStatusService(); // Create an instance of UserService
  late String classId;

  Future<List<Map<String, dynamic>>> fetchHomework() async {
    String? userStatus = await userService.getUserStatus();
    if (userStatus != 'student') {
      return [];
    }

    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      throw Exception("User not logged in");
    }

    DocumentSnapshot userDoc = await data.getDoc(
        FirebaseFirestore.instance.collection('users').doc(userId));

    var classField = userDoc.get('class'); // Use get to access the field
    if (classField == null) {
      return []; // Return an empty list if the class field is null
    } else if (classField is DocumentReference) {
      // Handle the case where the class field is a reference
      classId = classField.path;
    } else {
      throw Exception("Unexpected value type for class field");
    }

    List<DocumentSnapshot> homeworkDocs = await data.getHomework(classId);
    List<Future<Map<String, dynamic>>> homeworkFutures = homeworkDocs.map((task) async {
      var homeworkData = task.data() as Map<String, dynamic>;

      DocumentSnapshot subjectDoc = await data.getDoc(homeworkData['subject']);
      String subjectName = subjectDoc['name'];

      DateTime date = (homeworkData['endAt'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);

      return {
        'task': homeworkData['task'],
        'subject': subjectName,
        'teacher': homeworkData['teacher'],
        'date': formattedDate,
      };
    }).toList();

    return await Future.wait(homeworkFutures);
  }
}
