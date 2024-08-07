import 'package:flutter/material.dart';
import 'package:scientia/views/schedule_page.dart';
import 'package:scientia/widgets/schedule/day_item.dart';
import '../../models/daily_schedule.dart';
import '../st_chevron_right.dart';
import '../st_header.dart';
import '../st_row.dart';

class WeeklySchedule extends StatefulWidget {
  final List<dynamic> schedule;
  const WeeklySchedule({super.key, required this.schedule});

  @override
  State<WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  final int _currentWeekday = _getCustomWeekdayNumber(DateTime.now().weekday);
  late PageController pageController;
  double _boxHeight = 373;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController with the current weekday
    pageController = PageController(
      viewportFraction: 0.85,
      initialPage: _currentWeekday - 1, // Subtract 1 because PageView uses zero-based index
    );

    // Measure the data to set the initial height
    _measureData(widget.schedule);
  }

  void _measureData(List<dynamic> schedule) {
    bool allDaysShortSchedule = schedule.every((day) => day.schedule.length <= 6);
    _boxHeight = allDaysShortSchedule ? 290 : 373;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StRow(
          stHeader: StHeader(text: 'Schedule'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SchedulePage())
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SchedulePage())
            );
          },
        ),
        SizedBox(
          height: _boxHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.schedule.length,
            padEnds: false,
            itemBuilder: (context, index) {
              // Apply right padding only for the last item
              final isLastItem = index == widget.schedule.length - 1;
              return Padding(
                padding: EdgeInsets.only(left: 16, right: isLastItem ? 16 : 0),
                child: DayItem(dayData: widget.schedule[index]),
              );
            },
          )
        ),
      ],
    );
  }

  static int _getCustomWeekdayNumber(int weekday) {
    // Adjusting the weekday number to start from Sunday
    return weekday == DateTime.sunday ? 1 : weekday + 1;
  }
}
