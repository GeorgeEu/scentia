import 'package:flutter/material.dart';
import '../services/lesson_spot_service.dart';
import '../utils/formater.dart';
import 'st_snackbar.dart';

class LessonSpotWidget extends StatelessWidget {
  final Map<String, List<Map<String, TimeOfDay>>> lessonsPerDay;
  final Set<String> enabledDays;
  final Function(String) onAddLesson; // Updated to accept day abbreviation
  final Function(String, int) onDeleteLesson;
  final Function(String, int, TimeOfDay, bool) onTimeChanged;
  final Function(String, bool) onToggleDayEnabled;

  const LessonSpotWidget({
    Key? key,
    required this.lessonsPerDay,
    required this.enabledDays,
    required this.onAddLesson,
    required this.onDeleteLesson,
    required this.onTimeChanged,
    required this.onToggleDayEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
            ].map((dayFull) {
              final dayAbbr = Formater.longWeekDayToShort(dayFull);
              final isDayEnabled = enabledDays.contains(dayAbbr);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Day label and switch
                      Padding(
                        padding: const EdgeInsets.only(right: 40),
                        child: Row(
                          children: [
                            Text(dayFull, style: TextStyle(fontSize: 14)),
                            Switch(
                              value: isDayEnabled,
                              onChanged: (bool value) {
                                onToggleDayEnabled(dayAbbr, value); // Toggle day enabled/disabled
                              },
                            ),
                          ],
                        ),
                      ),
                      // Plus button in the same row (only if day is enabled)
                      if (isDayEnabled)
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.blue, size: 20),
                          onPressed: () => onAddLesson(dayAbbr), // Pass dayAbbr
                        ),
                    ],
                  ),
                  if (isDayEnabled) ...[
                    SizedBox(
                      height: (78.0 * lessonsPerDay[dayAbbr]!.length),
                      child: ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: lessonsPerDay[dayAbbr]!.length,
                        separatorBuilder: (context, index) => Divider(height: 16, thickness: 0.5, color: Colors.grey),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: _buildLessonItem(context, dayAbbr, index),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(BuildContext context, String dayAbbr, int index) {
    final Map<String, TimeOfDay> lesson = lessonsPerDay[dayAbbr]![index];

    return SizedBox(
      height: 52,
      child: Row(
        children: [
          // Start and End Time Pickers
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: lesson['startTime']!,
                    );
                    if (pickedTime != null) {
                      onTimeChanged(dayAbbr, index, pickedTime, true); // Change start time
                    }
                  },
                  child: Text('Start: ${lesson['startTime']!.format(context)}', style: TextStyle(fontSize: 12, color: Colors.blue, height: 1)),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: lesson['endTime']!,
                    );
                    if (pickedTime != null) {
                      onTimeChanged(dayAbbr, index, pickedTime, false); // Change end time
                    }
                  },
                  child: Text('End: ${lesson['endTime']!.format(context)}', style: TextStyle(fontSize: 12, color: Colors.blue, height: 1)),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => onDeleteLesson(dayAbbr, index), // Call delete callback
          ),
        ],
      ),
    );
  }
}


