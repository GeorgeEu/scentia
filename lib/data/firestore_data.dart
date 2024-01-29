import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreData {
  final _uid = "Tb3HelcRbnQZcxHok9l4YI5pwwI3";

  CollectionReference getExams() {
    final CollectionReference _exams =
        FirebaseFirestore.instance.collection('exams');
    return _exams;
  }

  CollectionReference getSubstitutions() {
    final CollectionReference _substitutions =
        FirebaseFirestore.instance.collection('substitutions');
    return _substitutions;
  }

  CollectionReference getEvents() {
    final CollectionReference _events =
        FirebaseFirestore.instance.collection('events');
    return _events;
  }

  Future<List<DocumentSnapshot>> getGrades(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('grades') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getSubjects() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot subjects = await firestore
        .collection('subjects') // Replace with your collection name
        .get();

    return subjects.docs;
  }

  Stream<List<Grade>> getDailyGrades(int timestamp) async* {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    Timestamp beginTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);
    var gradesStream = FirebaseFirestore.instance.collection("grades")
        .where('date', isGreaterThanOrEqualTo: beginTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .where('uid', isEqualTo: _uid).snapshots();
    var grades = <Grade>[];
    await for (var gradesSnapshot in gradesStream) {
      for (var gradesDoc in gradesSnapshot.docs) {
        var grade;
        if (gradesDoc["sid"] != null) {
          var subjectSnapshot = await FirebaseFirestore.instance.collection("subjects")
              .doc(gradesDoc["sid"])
              .get();

          Timestamp timestamp = gradesDoc["date"]; // Assuming date is a Timestamp
          DateTime date = timestamp.toDate();
          String formattedDate = DateFormat('EEEE').format(date); // Formatting date
          grade = Grade(
              formattedDate,
              gradesDoc["grade"],
              subjectSnapshot["name"]);
        }
        else {
          String formattedDate = DateFormat('EEEE').format(DateTime.now());
          grade = Grade(gradesDoc["grade"], "", formattedDate);
        }
        grades.add(grade);
      }
      yield grades;
    }
  }

}


class Grade {
  final String date;
  final grade;
  final name; // Changed type to String
  Grade(this.date, this.grade, this.name);
}