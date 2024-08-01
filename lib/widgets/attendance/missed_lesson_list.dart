import 'package:flutter/material.dart';
import 'package:scientia/widgets/empty_state_page.dart';
import 'package:scientia/widgets/empty_state_widget.dart';
import 'missed_lesson_item.dart';

class MissedLessonList extends StatelessWidget {
  final Map<String, double> absencePercentageMap;

  MissedLessonList({required this.absencePercentageMap});

  @override
  Widget build(BuildContext context) {
    return absencePercentageMap.isEmpty
        ? const Center(
      child: EmptyStatePage(
        message: "There are no lessons to miss",
      ),
    )
        : ListView.separated(
      itemCount: absencePercentageMap.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        String subject = absencePercentageMap.keys.elementAt(index);
        double percentage = absencePercentageMap[subject]!;
        return Padding(
          padding: EdgeInsets.only(
            bottom: index == absencePercentageMap.length - 1 ? 16.0 : 0.0, // Add padding only for the last item
          ),
          child: MissedLessonItem(
            subject: subject,
            percentage: percentage,
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(height: 0.5, thickness: 0.5, indent: 16),
    );
  }
}
