import 'package:flutter/material.dart';
import 'package:scientia/models/daily_schedule.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Ensure you have the flutter_svg package included in your pubspec.yaml file
import '../../utils/formater.dart';

class DayItem extends StatelessWidget {
  final dynamic dayData;
  const DayItem({super.key, required this.dayData});

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
                  Formater.shortWeekDayToLong(dayData.day),  // Assuming 'day' is something like 'Monday'
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              ),
              if (dayData.schedule.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dayData.schedule.length,
                  itemBuilder: (context, index) {
                    final lesson = dayData.schedule[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            lesson.start,  // Start time of the lesson
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            lesson.subjectName,  // Name of the subject
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

  void showEventBottomSheet(BuildContext context, dynamic dayData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,  // Adjust as needed
          minChildSize: 0.3,
          maxChildSize: 0.9,  // Adjust as needed
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                      child: SvgPicture.asset(
                        'assets/drag-handle.svg', // Path to your SVG file
                        width: 40,  // Adjust the size as needed
                        height: 4,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 10),
                    child: Text(
                      Formater.shortWeekDayToLong(dayData.day),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        height: 1,
                      ),
                    ),
                  ),
                  if (dayData.schedule.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: dayData.schedule.length,
                      itemBuilder: (context, index) {
                        final lesson = dayData.schedule[index];
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16),
                              child: Text(
                                '${lesson.start} - ${lesson.end}',  // Start and end time of the lesson
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
                                  lesson.subjectName,  // Name of the subject
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  lesson.teacherName,  // Name of the teacher
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(thickness: 0.5, indent: 16),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        'There are no lessons',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
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
}
