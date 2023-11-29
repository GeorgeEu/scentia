import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamsSegment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String formatDate(int timestamp) {
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
      String fdatetime = DateFormat('dd/MM/yyyy').format(tsdate);
      return fdatetime;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                /*The date of the exam from firestore*/
                '',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                /*The name of the exam from firestore*/
                '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
              Text(
                /*The room of the exam from firestore*/
                '',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text(
                /*The desc of the exam from firestore*/
                '',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
