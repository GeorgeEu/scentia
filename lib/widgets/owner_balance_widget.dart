import 'package:flutter/material.dart';

class OwnerBalanceWidget extends StatelessWidget {
  final int balance;
  const OwnerBalanceWidget({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
              'your balance',
            style: TextStyle(
              fontSize: 12,
              height: 1,
              color: Colors.white,
            ),
          ),
        ),
        Text(
            balance.toString(),
            style: TextStyle(
              fontSize: 16,
              height: 1,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )
        ),
      ],
    );
  }
}
