import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<String, dynamic> _day;
  late DateTime selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month; // Declare and initialize _calendarFormat

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Schedule',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
          ),
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: TableCalendar(
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
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
              });
            },
          ),
        ),
      ],
    );
  }
}
