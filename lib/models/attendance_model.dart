import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';
import '../services/auth_services.dart';

class AttendanceModel{
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchAttendance() async {
    String? userId = AuthService.getCurrentUserId();

    // Get the user's document reference
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Fetch the homework documents for the current user
    List<DocumentSnapshot> attendanceDocs = await data.getAttendance(userDocRef);
    List<Future<Map<String, dynamic>>> attendanceFutures = attendanceDocs.map((stuff) async {
      var attendanceData = stuff.data() as Map<String, dynamic>;

      Future<DocumentSnapshot> subjectDocFuture = data.getDoc(attendanceData['subject']);
      Future<DocumentSnapshot> teacherDocFuture = data.getDoc(attendanceData['teacher']);
      Future<DocumentSnapshot> lessonSlotDocFuture = data.getDoc(attendanceData['lesson']);

      DocumentSnapshot subjectDoc = await subjectDocFuture;
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      DocumentSnapshot lessonSlotDoc = await lessonSlotDocFuture;
      DocumentReference nestedSlotRef = lessonSlotDoc['lesson'] as DocumentReference;
      DocumentSnapshot nestedSlotDoc = await nestedSlotRef.get();
      String start = nestedSlotDoc['start'];
      String end = nestedSlotDoc['end'];

      DateTime date = (attendanceData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);

      return {
        'subject': subjectName,
        'start': start,
        'end': end,
        'date': formattedDate,
        'status': attendanceData['status'],
      };
    }).toList();

    return await Future.wait(attendanceFutures);
  }

  Future<Map<String, int>> fetchAttendanceCounts() async {
    String? userId = AuthService.getCurrentUserId();

    if (userId == null) {
      print("User is not logged in");
      return {'Absence': 0, 'Late': 0};
    }

    // Get the user's document reference
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

    // Fetch attendance documents for the current user
    List<DocumentSnapshot> attendanceDocs = await data.getAttendance(userDocRef);

    int absenceCount = 0;
    int lateCount = 0;

    for (var doc in attendanceDocs) {
      var data = doc.data() as Map<String, dynamic>;
      String status = data['status'];

      if (status == 'Absence') {
        absenceCount++;
      } else if (status == 'Late') {
        lateCount++;
      }
    }

    return {'Absence': absenceCount, 'Late': lateCount};
  }

}

