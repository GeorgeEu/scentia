import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/transaction_history.dart'; // Import intl for date formatting

class UsageHistory extends StatelessWidget {
  const UsageHistory({super.key});

  String formatTimestamp(int timestamp) {
    // Convert the timestamp to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // Format the date
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Usage Hisory',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            height: 1,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5), // Adjusts the height of the line
          child: Container(
            color: Colors.grey.shade300, // Gray color for the line
            height: 0.5,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: TransactionService().fetchUserTransactions(), // Fetch transactions
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching transactions'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found'));
          } else {
            final transactions = snapshot.data!;

            return ListView.separated(
              itemCount: transactions.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade300,
                height: 0.5,
              ),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final firestore = transaction['firestore'];
                final time = transaction['time'];

                // Format the time field
                final formattedTime = formatTimestamp(time);

                return ListTile(
                  leading: Icon(Icons.monetization_on_outlined, color: Colors.blue),
                  title: Text(
                    'Amount: $firestore',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Date: $formattedTime',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
