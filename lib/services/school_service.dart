import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/accounting.dart';
import 'auth_services.dart';

class SchoolService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getCurrentUserSchoolId() async {
    try {
      // Get the current user's UID
      String? userId = AuthService.getCurrentUserId();

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

      // Get the permission document
      DocumentSnapshot permissionDoc = await permissionDocRef.get();

      // Check if the permission document exists for the user
      if (!permissionDoc.exists) {
        print("Permission document does not exist for user: $userId");
        return null; // Stop further processing if no permission document exists
      }

      // Accounting operation
      await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 3);

      // Cast the document data to a Map<String, dynamic> to access it safely
      Map<String, dynamic>? data = permissionDoc.data() as Map<String, dynamic>?;

      // Check if the document has data and a 'school' field
      if (data != null && data.containsKey('school')) {
        DocumentReference? schoolRef = data['school'] as DocumentReference?;
        if (schoolRef != null) {
          return schoolRef.id; // Return the school document ID
        } else {
          print("School reference is null.");
          return null;
        }
      } else {
        print("'school' field does not exist in the permission document.");
        return null;
      }

    } catch (e) {
      print("Error getting school ID: $e");
      return null; // Return null in case of any errors
    }
  }
}
