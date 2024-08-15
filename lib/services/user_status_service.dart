import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/utils/accounting.dart';
import '../services/auth_services.dart';

class UserStatusService {
  final FirebaseFirestore data = FirebaseFirestore.instance;

  Future<String?> getUserStatus() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      return null; // Return null for not logged in users
    }

    try {
      DocumentSnapshot userDoc = await data
          .collection('users')
          .doc(userId)
          .collection('account')
          .doc('permission')
          .get();

      // Log the read operation (1 document read)
      await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 1);

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;
        return data?['status'] ?? ''; // Return empty string if status is not found
      } else {
        return ''; // Return empty string if the document does not exist
      }
    } catch (e) {
      print("Error fetching user status: $e");
      return null; // Handle errors by returning null or an empty string
    }
  }
}
