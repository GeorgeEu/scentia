import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/widgets/custom_row.dart';
import '../services/transaction_service.dart';

class CreditingFunds extends StatelessWidget {
  const CreditingFunds({super.key});

  String formatTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime today = DateTime.now();

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return 'Today';
    }
    return DateFormat('MMMM d, hh:mm a').format(date);
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
        title: const Text(
          'Crediting Funds',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            height: 1,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: Colors.grey.shade300,
            height: 0.5,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: TransactionService().fetchPositiveTransactionsWithPrices(),
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
                indent: 16,
                color: Colors.grey.shade300,
                thickness: 0.5,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final firestore = transaction['firestore'].toString();
                final time = transaction['time'];

                final formattedTime = formatTimestamp(time);

                return CustomRow(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  children: [
                    Text(
                      formattedTime,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    Text(
                      firestore,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
