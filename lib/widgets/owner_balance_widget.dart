import 'package:flutter/material.dart';

class OwnerBalanceWidget extends StatelessWidget {
  final int balance;
  const OwnerBalanceWidget({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24, bottom: 24, left: 16, right: 16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),
        alignment: Alignment.center,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Balance: ',
                style: TextStyle(
                  fontSize: 16,
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              TextSpan(
                text: balance.toString(),
                style: TextStyle(
                  fontSize: 18,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
