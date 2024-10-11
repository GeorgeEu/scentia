import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_services.dart'; // Assuming your AuthService is in this file

class UserExistanceCheck {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> doesDocumentExist() async {
    // Get the current user ID
    String? userId = AuthService.getCurrentUserId();

    // Check if user ID is not null
    if (userId == null) {
      return false;
    }

    // Reference to the document with the user ID
    DocumentSnapshot doc = await _firestore.collection('scentia').doc(userId).get();

    // Return true if the document exists, otherwise false
    return doc.exists;
  }
}
