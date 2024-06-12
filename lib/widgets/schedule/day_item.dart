import 'package:flutter/material.dart';
import 'package:scientia/models/daily_schedule.dart';

class DayItem extends StatelessWidget {
  final DailySchedule dayData;
  DayItem(this.dayData);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 11, bottom: 11, left: 16, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  dayData.day,  // Assuming 'day' is something like 'Monday'
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                ),
              ),
              ...dayData.schedule.map((Subject subject) => Container(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        subject.start,  // Start time of the lesson
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        subject.name,  // Name of the subject
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )),
              if (dayData.schedule.isEmpty)
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
    );
  }
}
