import 'package:flutter/material.dart';

class AbsenceSummarySegment extends StatelessWidget {
  final Map<String, dynamic> _attendance;

  AbsenceSummarySegment(this._attendance);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16)
      ),
      child:  Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black12,
                child: Icon(
                  Icons.gpp_bad_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Absence',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1,
                    fontSize: 16
                  ),
                ),
                Text(
                  _attendance['absences'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    height: 1,
                    fontSize: 18
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
