import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_services.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUserTransactions() async {
    try {
      // Get the current user ID
      String? userId = AuthService.getCurrentUserId();
      if (userId == null) {
        throw Exception("User ID is null");
      }

      // Reference to the user's transactions document
      DocumentSnapshot userTransactionsDoc =
      await _firestore.collection('transactions').doc(userId).get();

      // Check if the document exists and contains the 'transactionList' field
      if (userTransactionsDoc.exists &&
          userTransactionsDoc.data() != null &&
          (userTransactionsDoc.data() as Map<String, dynamic>)
              .containsKey('transactionsList')) {
        // Extract the transaction list
        List<dynamic> transactionList =
        (userTransactionsDoc.data() as Map<String, dynamic>)['transactionsList'];

        // Format the transaction list into a list of maps
        List<Map<String, dynamic>> formattedTransactions = transactionList
            .map((transaction) => {
          'firestore': transaction['firestore'],
          'time': transaction['time'],
        })
            .toList();

        return formattedTransactions;
      } else {
        // Return an empty list if there are no transactions
        return [];
      }
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }
}
