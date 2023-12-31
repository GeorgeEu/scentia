import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FullEvent extends StatelessWidget {
  final Map<String, dynamic> _event;

  FullEvent(this._event);

  @override
  Widget build(BuildContext context) {
    String formatDate(int timestamp) {
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
      String fdatetime = DateFormat('MMMM dd • hh:mm a').format(tsdate);
      return fdatetime;
    }

    return InkWell(
      onTap: () {
        showEventBottomSheet(context);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8, top: 4),
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
                  padding: EdgeInsets.only(left: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDate(_event['Date']),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            fontSize: 15
                        ),
                      ),
                      Text(
                        _event['Name'].toString(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),
                      ),
                      Text(
                        _event['Address'].toString(),
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
  void showEventBottomSheet(BuildContext context) {
    String formatDate(int timestamp) {
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
      String fdatetime = DateFormat('MMMM dd • hh:mm a').format(tsdate);
      return fdatetime;
    }
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 350,
                    height: 216,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        _event['ImagePath'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      formatDate(_event['Date']),
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                  ),
                  Text(
                    _event['Name'].toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _event['Address'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),
                    ),
                  ),
                  Text(
                    _event['Desc'].toString(),
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
