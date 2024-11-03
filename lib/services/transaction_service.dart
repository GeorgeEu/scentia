import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_services.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAndProcessUserTransactions() async {
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
        List<dynamic> transactionList =
        (userTransactionsDoc.data() as Map<String, dynamic>)['transactionsList'];

        // Sort transactions by timestamp in descending order
        transactionList.sort((a, b) => b['time'].compareTo(a['time']));

        List<Map<String, dynamic>> processedTransactions = [];
        dynamic dailySum = 0;
        DateTime? currentDay;

        for (var transaction in transactionList) {
          dynamic firestoreValue = transaction['firestore'];
          DateTime transactionDate =
          DateTime.fromMillisecondsSinceEpoch(transaction['time']);
          DateTime transactionDay = DateTime(
              transactionDate.year,
              transactionDate.month,
              transactionDate.day
          );

          // If we encounter a new day or a positive transaction
          if (firestoreValue >= 0 || currentDay != transactionDay) {
            // Add the previous day's accumulated sum if it exists
            if (dailySum != 0) {
              processedTransactions.add({
                'firestore': dailySum < 0
                    ? dailySum.toStringAsFixed(4)
                    : '+${dailySum.toStringAsFixed(4)}', // Add + sign for positive
                'time': currentDay?.millisecondsSinceEpoch ?? transaction['time']
              });
              dailySum = 0; // Reset daily sum
            }

            // For positive transactions, add them directly to the list
            if (firestoreValue >= 0) {
              processedTransactions.add({
                'firestore': '+${firestoreValue}', // Add + sign for positive
                'time': transaction['time']
              });
              currentDay = null; // Reset current day for new grouping after positive transaction
              continue;
            } else {
              // Update the current day to the new transaction day for minus grouping
              currentDay = transactionDay;
              dailySum += firestoreValue;
            }
          } else {
            // Accumulate the sum for consecutive minus transactions on the same day
            dailySum += firestoreValue;
          }
        }

        // Add the last accumulated sum if there's any left after the loop
        if (dailySum != 0) {
          processedTransactions.add({
            'firestore': dailySum < 0
                ? dailySum.toStringAsFixed(4)
                : '+${dailySum.toStringAsFixed(4)}', // Add + sign for positive
            'time': currentDay?.millisecondsSinceEpoch
          });
        }

        return processedTransactions;
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchPositiveTransactionsWithPrices() async {
    try {
      // Get the current user ID
      String? userId = AuthService.getCurrentUserId();
      if (userId == null) {
        throw Exception("User ID is null");
      }

      // Reference to the user's transactions document
      DocumentSnapshot userTransactionsDoc =
      await _firestore.collection('transactions').doc(userId).get();

      // Check if the document exists and contains the 'transactionsList' field
      if (userTransactionsDoc.exists &&
          userTransactionsDoc.data() != null &&
          (userTransactionsDoc.data() as Map<String, dynamic>)
              .containsKey('transactionsList')) {
        // Explicitly cast the transaction list to List<Map<String, dynamic>>
        List<Map<String, dynamic>> transactionList = List<Map<String, dynamic>>.from(
            (userTransactionsDoc.data() as Map<String, dynamic>)['transactionsList']);

        // Filter only positive transactions
        List<Map<String, dynamic>> processedPositiveTransactions = transactionList
            .where((transaction) => transaction['firestore'] > 0)
            .toList();

        // Fetch 'usd' documents from 'accounting/offers'
        QuerySnapshot usdDocuments = await _firestore
            .collection('accounting')
            .doc('offers')
            .collection('usd')
            .get();

        // Create a map to store tokens and their corresponding prices
        Map<int, double> tokensToPriceMap = {
          for (var doc in usdDocuments.docs)
            (doc['tokens'] as int): (doc['price'] as double)
        };

        // Replace tokens with corresponding prices in the positive transactions
        processedPositiveTransactions = processedPositiveTransactions.map((transaction) {
          int tokens = transaction['firestore'];
          double? price = tokensToPriceMap[tokens];
          return {
            'firestore': price != null ? '\$$price' : '\$$tokens', // Use price if available, else tokens
            'time': transaction['time']
          };
        }).toList();

        processedPositiveTransactions.sort((a, b) => b['time'].compareTo(a['time']));

        return processedPositiveTransactions;
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching transactions with prices: $e");
      return [];
    }
  }
}
