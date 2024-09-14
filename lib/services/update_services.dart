import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateServices {
  Future<void> updateEvent(String documentId, String name, String classReferencePath, String description) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(documentId)
          .update({
        'name': name,
        'class': FirebaseFirestore.instance.doc(classReferencePath), // Convert the class path to a DocumentReference
        'desc': description,
      });
    } catch (e) {
      print('Error updating event: $e');
      throw Exception('Failed to update event');
    }
  }
}

