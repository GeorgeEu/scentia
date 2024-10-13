import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_services.dart'; // Import your AuthService

class OwnerBalance {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int?> getUserBalance() async {
    String? userId = AuthService.getCurrentUserId();

    if (userId != null) {
      try {
        // Assuming the collection where the balance is stored is 'scentia'
        DocumentSnapshot userDoc = await _firestore.collection('scentia').doc(userId).get();
        if (userDoc.exists) {
          // Cast the document data to a Map<String, dynamic> before accessing fields
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
          if (data != null) {
            // Handle both int and double types
            dynamic balanceValue = data['balance'];
            if (balanceValue is int) {
              // If it's an int, convert it to double
              double balance = balanceValue.toDouble();
              int roundedBalance = (balance * 1000).round();
              return roundedBalance;
            } else if (balanceValue is double) {
              // If it's already a double, handle it directly
              int roundedBalance = (balanceValue * 1000).round();
              return roundedBalance;
            }
          }
        }
      } catch (e) {
        print("Error retrieving balance: $e");
        return null;
      }
    } else {
      print("User ID is null");
      return null;
    }
    return null;
  }
}
