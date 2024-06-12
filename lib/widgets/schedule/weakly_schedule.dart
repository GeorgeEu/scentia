import 'package:flutter/material.dart';
import 'package:scientia/views/schedule_page.dart';
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              const Text(
                'Weekly Schedule',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const Spacer(),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SchedulePage()
                  ));
                },
                child: const Text(
                  'Show More',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
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
}
