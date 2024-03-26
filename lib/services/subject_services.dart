import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'firestore_data.dart';

class SubjectServices {
  final FirestoreData data = FirestoreData();
  static List<Map<String, dynamic>> subjects = []; // Initialize as an empty list
  void initialize() async {
    List<DocumentSnapshot> docs = await data.getSubjects();
    for (var doc in docs) {
      Map<String, dynamic> subject = doc.data() as Map<String, dynamic>;
      subject['id'] = doc.id;
      subjects.add(subject); // No need for null check
    }
  }

  String getSubjectById(String id) {
    try {
      var subject = subjects.firstWhere((subject) => subject['id'] == id);
      return subject['name']; // Assuming 'name' is always a String
    } catch (e) {
      // Handle the case where no match is found or any other exception
      return 'No subject found with id $id';
    }
  }
}