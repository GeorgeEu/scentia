// schedule_test_widget.dart
import 'package:flutter/material.dart';

// Import your custom classes and services
import '../services/grade_creation_service.dart';
import '../services/lesson_spot_service.dart';
import '../utils/formater.dart';
import '../widgets/custom_menu.dart';
import '../widgets/st_snackbar.dart';

class LessonSpotWidget extends StatefulWidget {
  final List<Class> classes;

  const LessonSpotWidget({Key? key, required this.classes}) : super(key: key);

  @override
  _LessonSpotWidgetState createState() => _LessonSpotWidgetState();
}

class _LessonSpotWidgetState extends State<LessonSpotWidget> {
  final TextEditingController _classController = TextEditingController();
  String? _selectedClass;

  Map<String, List<Map<String, TimeOfDay>>> lessonsPerDay = {
    'SUN': [],
    'MON': [],
    'TUE': [],
    'WED': [],
    'THU': [],
    'FRI': [],
    'SAT': [],
  };

  Set<String> enabledDays = {};

  @override
  void initState() {
    super.initState();

    // Optionally, initialize Sunday as enabled with one lesson
    final sundayAbbreviation = Formater.longWeekDayToShort('Sunday');
    enabledDays.add(sundayAbbreviation);
    lessonsPerDay[sundayAbbreviation] = [
      {
        'startTime': TimeOfDay(hour: 9, minute: 0),
        'endTime': TimeOfDay(hour: 10, minute: 0)
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
        const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Selection Dropdown
            CustomDropdownMenu<Class>(
              widthWidget: MediaQuery.of(context).size.width,
              horizontalPadding: 16,
              label: const Text('Class'),
              title: 'Select Class',
              controller: _classController,
              items: widget.classes,
              itemTitleBuilder: (classItem) => classItem.name,
              onSelected: (classItem) {
                setState(() {
                  _selectedClass = classItem.name;
                });
              },
            ),

            // Day Switches with Plus Button and Lessons
            Column(
              children: [
                'Sunday',
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday'
              ].map((dayFull) {
                final dayAbbr =
                Formater.longWeekDayToShort(dayFull);
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
                              Text(dayFull,
                                  style: TextStyle(fontSize: 14)),
                              Switch(
                                value: isDayEnabled,
                                onChanged: (bool value) {
                                  setState(() {
                                    if (value) {
                                      // Enable day
                                      enabledDays.add(dayAbbr);
                                    } else {
                                      // Disable day
                                      enabledDays.remove(dayAbbr);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        // Plus button in the same row (only if day is enabled)
                        if (isDayEnabled)
                          IconButton(
                            icon: Icon(Icons.add_circle,
                                color: Colors.blue, size: 20),
                            onPressed: () {
                              setState(() {
                                lessonsPerDay[dayAbbr]!.add({
                                  'startTime':
                                  TimeOfDay(hour: 9, minute: 0),
                                  'endTime':
                                  TimeOfDay(hour: 10, minute: 0),
                                });
                              });
                            },
                          ),
                      ],
                    ),
                    if (isDayEnabled) ...[
                      // Responsive Lessons List
                      SizedBox(
                        height: (78.0 *
                            lessonsPerDay[dayAbbr]!
                                .length), // Responsive height
                        child: ListView.separated(
                          physics:
                          NeverScrollableScrollPhysics(),
                          itemCount: lessonsPerDay[dayAbbr]!.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 16,
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 5.0),
                              child: _buildLessonItem(dayAbbr, index),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                );
              }).toList(),
            ),

            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedClass == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      StSnackBar(message: 'Please select a class before saving.'),
                    );
                    return;
                  }

                  try {
                    LessonSpotService lessonSpotService = LessonSpotService();
                    await lessonSpotService.saveLessonSpots(
                        _selectedClass!, lessonsPerDay);

                    ScaffoldMessenger.of(context).showSnackBar(
                      StSnackBar(message: 'Lesson spots successfully saved.'),
                    );

                    // Optionally, reset the form or navigate back
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error saving lesson spots: $e')),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build each lesson item
  Widget _buildLessonItem(String dayAbbr, int index) {
    final Map<String, TimeOfDay> lesson = lessonsPerDay[dayAbbr]![index];

    return SizedBox(
      height: 52, // Height of each row
      child: Row(
        children: [
          // Column for Start and End Time Pickers wrapped in GestureDetector
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
                      setState(() {
                        lesson['startTime'] = pickedTime;
                      });
                    }
                  },
                  child: Text(
                    'Start: ${lesson['startTime']!.format(context)}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.blue, height: 1),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: lesson['endTime']!,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        lesson['endTime'] = pickedTime;
                      });
                    }
                  },
                  child: Text(
                    'End: ${lesson['endTime']!.format(context)}',
                    style: TextStyle(
                        fontSize: 12, color: Colors.blue, height: 1),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
              width:
              16), // Spacing between time column and delete button
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () {
              setState(() {
                lessonsPerDay[dayAbbr]!.removeAt(index);
                // Keep the day in lessonsPerDay even if the list becomes empty
              });
            },
          ),
        ],
      ),
    );
  }
}
