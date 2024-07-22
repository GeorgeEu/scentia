import 'package:flutter/material.dart';
import 'package:scientia/models/daily_schedule.dart';

import '../../utils/formater.dart';

class DayItem extends StatelessWidget {
  final DailySchedule dayData;
  const DayItem(this.dayData, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showEventBottomSheet(context, dayData);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 11, bottom: 11, left: 16),
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
              if (dayData.schedule.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dayData.schedule.length,
                  itemBuilder: (context, index) {
                    final subject = dayData.schedule[index];
                    return Row(
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
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(thickness: 0.5),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
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

void showEventBottomSheet(BuildContext context, DailySchedule dayData) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,  // Adjust as needed
        minChildSize: 0.3,  // Adjust as needed
        maxChildSize: 0.8,  // Adjust as needed
        builder: (BuildContext context, ScrollController scrollController) {
          return Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    Formater.shortWeekDayToLong(dayData.day),  // Assuming 'day' is something like 'Monday'
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ),
                if (dayData.schedule.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: dayData.schedule.length,
                      itemBuilder: (context, index) {
                        final subject = dayData.schedule[index];
                        return Row(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.name,  // Name of the subject
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  subject.teacher,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(thickness: 0.5),
                    ),
                  )
                else
                  const SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'There are no lessons',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}


