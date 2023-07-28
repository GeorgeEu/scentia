import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullEvent extends StatelessWidget {
  final Map<String, String> _event;

  FullEvent(this._event);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white
        ),
        child: Padding(
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
        ),
      ),
    );
  }
}
