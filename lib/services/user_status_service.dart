import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_services.dart';

class UserStatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getUserStatus() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      return 'student'; // Default to 'student' if no user is logged in
    }

    DocumentReference userDocRef = _firestore.collection('users').doc(userId);
    DocumentSnapshot userDoc = await userDocRef.get();

    // Cast the data to Map<String, dynamic> before accessing it
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    return userData?['status'] ?? 'student'; // Default to 'student' if status is not found
  }
}
