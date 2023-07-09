import 'package:flutter/material.dart';

class DayItem extends StatelessWidget {
  final Map<String, dynamic> _day;

  DayItem(
    this._day,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _day['Date'],
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          ),
                          Text(
                            _day['Day'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                            ),
                          )
                        ]),
                  ),
                  Column(
                    children: [
                      for (var lesson in _day['Schedule'])
                        Container(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                  lesson['Time'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  lesson['Name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 23),
                                ),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
