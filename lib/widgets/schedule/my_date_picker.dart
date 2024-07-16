import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const MyDatePicker({super.key, required this.onDateSelected});

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  late DateTime selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

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
                widget.onDateSelected(selectedDay); // Notify parent widget
                // Automatically navigate back to the schedule tab
                DefaultTabController.of(context).animateTo(0);
              },
            ),
          ),
        ),
      ],
    );
  }
}
