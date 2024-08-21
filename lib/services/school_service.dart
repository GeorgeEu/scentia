import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/accounting.dart';
import 'auth_services.dart';

class SchoolService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentUserSchoolId() async {
    try {
      // Get the current user's UID
      String? userId = AuthService.getCurrentUserId();
      //print("Current user ID: $userId");
      if (userId == null) {
        print("User not logged in.");
        return null; // User not logged in
      }

      // Build the path to the permission document
      DocumentReference permissionDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('account')
          .doc('permission');
      //print("Permission document reference created: ${permissionDocRef.path}");

      // Get the permission document
      DocumentSnapshot permissionDoc = await permissionDocRef.get();
      //print("Permission document snapshot: ${permissionDoc.exists ? 'Exists' : 'Does not exist'}");

      // Accounting operation
      await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 3);
      //print("Accounting operation recorded.");

      // Check if the document exists and has the 'school' field
      if (permissionDoc.exists && permissionDoc.data() != null) {
        DocumentReference? schoolRef = permissionDoc.get('school');
        //print("School reference: ${schoolRef?.path}");
        if (schoolRef != null) {
          //print("Returning school ID: ${schoolRef.id}");
          return schoolRef.id; // Return the school document ID
        } else {
          print("School reference is null.");
        }
      } else {
        print("Permission document does not exist or has no data.");
      }

      return null; // If no school reference is found
    } catch (e) {
      print("Error getting school ID: $e");
      return null; // Return null in case of any errors
    }
  }
}
