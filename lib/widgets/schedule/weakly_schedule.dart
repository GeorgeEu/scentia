import 'package:flutter/material.dart';
import 'package:scientia/widgets/schedule/day_item.dart';
import '../../models/daily_schedule.dart';

class WeeklySchedule extends StatefulWidget {
  final Future<List<DailySchedule>> schedule;
  const WeeklySchedule(this.schedule, {super.key});

  @override
  State<WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  PageController pageController = PageController(viewportFraction: 0.85);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: FutureBuilder<List<DailySchedule>>(
        future: widget.schedule,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return PageView.builder(
              controller: pageController,
              itemCount: snapshot.data!.length,
              padEnds: false,
              itemBuilder: (context, index) {
                // Apply right padding only for the last item
                final isLastItem = index == snapshot.data!.length - 1;
                return Padding(
                  padding: EdgeInsets.only(left: 16, top: 16, right: isLastItem ? 16 : 0),
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
    );
  }
}
