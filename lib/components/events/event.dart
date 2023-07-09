import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  final Map<String, String> _event;

  Event(this._event);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                _event['ImagePath'].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _event['Date'].toString(),
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 16
                    ),
                  ),
                  Text(
                    _event['Name'].toString(),
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        fontSize: 22
                    ),
                  ),
                  Text(
                    _event['Desc'].toString(),
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
    // return Padding(
    //     padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 8),
    //     child: Expanded(
    //       child: Container(
    //         color: Colors.grey,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             SizedBox(
    //               width: 80,
    //               height: 80,
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(8),
    //                 // Adjust the value to control the corner roundness
    //                 child: Image.asset(
    //                   _event['ImagePath'].toString(),
    //                   fit: BoxFit.cover,
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(left: 16),
    //               child: Expanded(
    //                 child: Container(
    //                   color: Colors.pinkAccent,
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         _event['Date'].toString(),
    //                         style: const TextStyle(
    //                           color: Colors.grey,
    //                           overflow: TextOverflow.ellipsis,
    //                           fontWeight: FontWeight.normal,
    //                           fontSize: 16,
    //                         ),
    //                       ),
    //                       Text(
    //                         _event['Name'].toString(),
    //                         style: const TextStyle(
    //                           fontWeight: FontWeight.w600,
    //                           overflow: TextOverflow.ellipsis,
    //                           fontSize: 22,
    //                         ),
    //                       ),
    //                       Text(
    //                         _event['Desc'].toString(),
    //                         style: const TextStyle(
    //                           fontSize: 16,
    //                           overflow: TextOverflow.ellipsis,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ));
  }
}
