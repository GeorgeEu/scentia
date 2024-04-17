import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_data.dart';

class SubjectServices {
  final FirestoreData data = FirestoreData();
  static List<Map<String, dynamic>> subjects = [];
  bool _isInitialized = false; // New flag to track initialization status

  Future<void> initialize() async {
    if (!_isInitialized) {
      List<DocumentSnapshot> docs = await data.getSubjects();
      for (var doc in docs) {
        Map<String, dynamic> subject = doc.data() as Map<String, dynamic>;
        subject['id'] = doc.id;
        subjects.add(subject);
      }
      _isInitialized = true; // Set to true after successful initialization
    }
  }

  Future<String> getSubjectById(String id) async {
    // Ensure subjects are loaded before proceeding
    if (!_isInitialized) {
      await initialize(); // Await initialization if not done yet
    }
    try {
      var subject = subjects.firstWhere((subject) => subject['id'] == id);
      return subject['name']; // Assuming 'name' is a valid key
    } catch (e) {
      // Return a more descriptive error message or handle differently
      return 'Subject data not ready or no subject found with id $id';
    }
  }
}
