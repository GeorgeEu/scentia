import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubstituteTeacher extends StatelessWidget {
  final Map<String, dynamic> _substitutions;

  SubstituteTeacher(this._substitutions);

  @override
  Widget build(BuildContext context) {
    String formatDate(int timestamp) {
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String fdatetime = DateFormat('MMM dd').format(tsdate); // Corrected the format string to 'yyyy'
      return fdatetime;
    }
    return Padding(
      padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _substitutions['Lesson'],
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 18
                      ),
                    ),
                    Text(
                      _substitutions['Guru'].toString(),
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          fontSize: 22
                      ),
                    ),
                    Text(
                      _substitutions['SubstituteGuru'].toString(),
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
          ),
          Text(
            formatDate(_substitutions['Date']),
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                fontSize: 16
            ),
          ),
        ],
      ),
    );
  }
  void showEventBottomSheet(BuildContext context) {
    String formatDate(int timestamp) {
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      String fdatetime = DateFormat('MMMM dd, yyyy').format(tsdate); // Corrected the format string to 'yyyy'
      return fdatetime;
    }
    // showModalBottomSheet(
    //     context: context,
    //     showDragHandle: true,
    //     isScrollControlled: true,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    //     ),
    //     builder: (BuildContext context) {
    //       return SizedBox(
    //         width: double.infinity,
    //         child: Padding(
    //           padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Center(
    //                 child: SizedBox(
    //                   width: 300,
    //                   height: 250,
    //                   child: ClipRRect(
    //                     borderRadius: BorderRadius.circular(8),
    //                     child: Image.asset(
    //                       _event['ImagePath'].toString(),
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 16),
    //                 child: Text(
    //                   formatDate(_event['Date']),
    //                   style: TextStyle(
    //                       overflow: TextOverflow.ellipsis,
    //                       fontWeight: FontWeight.normal,
    //                       color: Colors.grey,
    //                       fontSize: 16
    //                   ),
    //                 ),
    //               ),
    //               Text(
    //                 _event['Name'].toString(),
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.w600,
    //                     fontSize: 30
    //                 ),
    //               ),
    //               Text(
    //                 _event['Desc'].toString(),
    //                 style: TextStyle(
    //                     fontSize: 16
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
}
