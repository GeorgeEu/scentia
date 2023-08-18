import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamsSegment extends StatelessWidget {
  final Map<String, dynamic> _exam;

  ExamsSegment(this._exam);

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
                formatDate(_exam['Date']),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                _exam['Name'].toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
              Text(
                _exam['Room'].toString(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
              Text(
                _exam['Desc'],
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
