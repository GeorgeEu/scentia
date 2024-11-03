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
      Map<String, dynamic>? data =
      permissionDoc.data() as Map<String, dynamic>?;

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

  // New method to fetch the current user's school name
  Future<String?> getCurrentUserSchoolName() async {
    try {
      // Get the current user's school ID
      String? schoolId = await getCurrentUserSchoolId();

      if (schoolId == null) {
        print("No school ID found for the current user.");
        return null; // No school ID associated with the user
      }

      // Reference to the school document
      DocumentReference schoolDocRef =
      _firestore.collection('schools').doc(schoolId);

      // Get the school document
      DocumentSnapshot schoolDoc = await schoolDocRef.get();

      // Check if the school document exists
      if (!schoolDoc.exists) {
        print("School document does not exist for school ID: $schoolId");
        return null; // School document does not exist
      }

      // Accounting operation
      await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 3);

      // Cast the document data to a Map<String, dynamic>
      Map<String, dynamic>? data = schoolDoc.data() as Map<String, dynamic>?;

      // Check if data is not null and contains 'name' field
      if (data != null && data.containsKey('name')) {
        String? schoolName = data['name'] as String?;
        if (schoolName != null) {
          return schoolName; // Return the school name
        } else {
          print("School name is null.");
          return null;
        }
      } else {
        print("'name' field does not exist in the school document.");
        return null;
      }
    } catch (e) {
      print("Error getting school name: $e");
      return null; // Return null in case of any errors
    }
  }
}
