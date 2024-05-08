import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/widgets/schedule/day_item.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:scientia/services/schedule_data/schedule_data.dart';

import '../../models/daily_schedule.dart';
import '../../services/firestore_data.dart';


class WeeklySchedule extends StatefulWidget {
  final Future<List<DailySchedule>> schedule;
  WeeklySchedule(this.schedule, {super.key});

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
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: DayItem(snapshot.data![index]),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}


