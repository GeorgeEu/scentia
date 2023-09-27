import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scientia/components/homework/homework_segment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scientia/data/home_work_data/homework_data.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var _homework = HomeworkData();
  late DateTime selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

  // Method to show the bottom sheet with homework details
  void _showHomeworkBottomSheet(DateTime day) {
    final homework = _homework.getDailyHomework(day.millisecondsSinceEpoch);
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return makeDismissible(
          child: DraggableScrollableSheet(
            initialChildSize: 0.70,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            builder: (_, controller) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: Colors.grey.shade300
                        )
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 8),
                      child: Text(
                        'Homework',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: homework.map((hw) {
                        return ListTile(
                          title: Text(
                            hw['Name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            hw['Task'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget makeDismissible({required Widget child}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(onTap: () {}, child: child),
  );


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: TableCalendar(
              eventLoader: (day) => _homework.getDailyHomework(day.millisecondsSinceEpoch),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: selectedDay,
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              // Inside your _CalendarState class
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                });

                final dailyHomework = _homework.getDailyHomework(selectedDay.millisecondsSinceEpoch);
                if (dailyHomework.isNotEmpty) {
                  _showHomeworkBottomSheet(selectedDay);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
