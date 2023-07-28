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
  }
}
