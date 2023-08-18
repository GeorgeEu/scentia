import 'package:flutter/material.dart';

class FullAbsenceSegment extends StatelessWidget {
  final Map<String, dynamic> _attendance;

  FullAbsenceSegment(this._attendance);

  @override
  Widget build(BuildContext context) {
    // print(_attendance);
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      'Absence',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ),
                  Text(
                    _attendance['absences'].toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            'Late',
                            style: TextStyle(
                                fontSize: 20,
                            ),
                          ),
                        ),
                        Text(
                          _attendance['lates'].toString(),
                          style: TextStyle(
                              fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    );
  }
}
