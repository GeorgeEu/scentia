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
}

// class Subjects {
//   final List<Map<String, dynamic>> _subjects = [];
//
//   void initialize(VoidCallback onDone) async {
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     QuerySnapshot querySnapshot = await firestore.collection('subjects').get();
//     _subjects.addAll(querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>));
//     onDone();
//   }
//
//   String getSubjectById(String id) {
//     try {
//       var subject = _subjects.firstWhere((subject) => subject['id'] == id);
//       return subject['name']; // Assuming 'name' is a key in the subject document
//     } catch (e) {
//       return 'No subject found with id $id';
//     }
//   }
// }


