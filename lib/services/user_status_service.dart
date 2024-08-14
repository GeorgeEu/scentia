import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/utils/accounting.dart';
import '../services/auth_services.dart';

class UserStatusService {
  final FirebaseFirestore data = FirebaseFirestore.instance;

  Future<String> getUserStatus() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      return 'student'; // Default to 'student' if no user is logged in
    }

    DocumentReference userDocRef = data.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userDocRef.get();

    // Log the read operation (1 document read)
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 1);

    // Cast the data to Map<String, dynamic> before accessing it
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    return userData?['status'] ?? 'student'; // Default to 'student' if status is not found
  }
}
