import 'package:flutter/material.dart';
import 'package:scientia/views/schedule_page.dart';
import 'package:scientia/widgets/schedule/day_item.dart';
import '../../models/daily_schedule.dart';
import '../st_chevron_right.dart';
import '../st_header.dart';
import '../st_row.dart';

class WeeklySchedule extends StatefulWidget {
  final Future<List<DailySchedule>> schedule;
  const WeeklySchedule(this.schedule, {super.key});

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
          child: FutureBuilder<List<DailySchedule>>(
            future: widget.schedule,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {

                // Check if all days have 6 or fewer subjects
                bool allDaysShortSchedule = snapshot.data!.every((day) => day.schedule.length <= 6);

                // Update the height if necessary
                if (allDaysShortSchedule && _boxHeight != 290) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _boxHeight = 290;
                    });
                  });
                } else if (!allDaysShortSchedule && _boxHeight != 373) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _boxHeight = 373;
                    });
                  });
                }

                return PageView.builder(
                  controller: pageController,
                  itemCount: 7,
                  padEnds: false,
                  itemBuilder: (context, index) {
                    // Apply right padding only for the last item
                    final isLastItem = index == snapshot.data!.length - 1;
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: isLastItem ? 16 : 0),
                      child: DayItem(snapshot.data![index]),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  static int _getCustomWeekdayNumber(int weekday) {
    // Adjusting the weekday number to start from Sunday
    return weekday == DateTime.sunday ? 1 : weekday + 1;
  }
}
