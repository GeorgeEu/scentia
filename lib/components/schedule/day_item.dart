import 'package:flutter/material.dart';

class DayItem extends StatelessWidget {
  final Map<String, dynamic> day;

  DayItem(this.day);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.only(top: 11, bottom: 11, left: 16, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day['day'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          )
                        ]),
                  ),
                  if (day['schedule'] != null && day['schedule'].isNotEmpty)
                    for (var lesson in day['schedule'])
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
                                    fontSize: 15,
                                    color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                lesson['Name'],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'There are no lessons',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
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
