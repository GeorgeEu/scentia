import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateServices {
  Future<void> updateEvent(String documentId, String name,
      String classReferencePath, String description, String? imageUrl, Timestamp date) async {
    try {
      Map<String, dynamic> updatedData = {
        'name': name,
        'class': FirebaseFirestore.instance.doc(classReferencePath),
        'date': date,
        'desc': description,
      };

      // Only add imageUrl to the update if it's not null
      if (imageUrl != null) {
        updatedData['imageUrl'] = imageUrl;
      }

      await FirebaseFirestore.instance
          .collection('events')
          .doc(documentId)
          .update(updatedData);

      print('Event updated successfully');
    } catch (e) {
      print('Error updating event: $e');
      throw Exception('Failed to update event');
    }
  }

  Future<void> updateHomework(String documentId, String subjectReferencePath,
      String classReferencePath, String task, Timestamp date) async {
    try {
      Map<String, dynamic> updatedData = {
        'task': task,
        'class': FirebaseFirestore.instance.doc(classReferencePath),
        'subject': FirebaseFirestore.instance.doc(subjectReferencePath),
        'endAt': date
        // Convert the class path to a DocumentReference
      };

      // Only add imageUrl to the update if it's not null
      await FirebaseFirestore.instance
          .collection('homework')
          .doc(documentId)
          .update(updatedData);

      print('Homework updated successfully');
    } catch (e) {
      print('Error updating homework: $e');
      throw Exception('Failed to update homework');
    }
  }

  Future<void> updateGrade(String documentId, String studentReferencePath, String subjectReferencePath, int grade, Timestamp date) async {
    try {
      Map<String, dynamic> updatedData = {
        'grade': grade, // Store grade as an int
        'uid': FirebaseFirestore.instance.doc(studentReferencePath),
        'sid': FirebaseFirestore.instance.doc(subjectReferencePath),
        'date': date,
      };

      await FirebaseFirestore.instance
          .collection('grades')
          .doc(documentId)
          .update(updatedData);

      print('Grade updated successfully');
    } catch (e) {
      print('Error updating grade: $e');
      throw Exception('Failed to update grade');
    }
  }
}
