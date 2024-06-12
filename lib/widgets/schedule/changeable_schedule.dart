import 'package:flutter/material.dart';
import 'package:scientia/widgets/schedule/day_item.dart';
import '../../models/daily_schedule.dart';

class ChangeableSchedule extends StatefulWidget {
  final Future<List<DailySchedule>> schedule;
  const ChangeableSchedule(this.schedule, {super.key});

  @override
  State<ChangeableSchedule> createState() => _ChangeableScheduleState();
}

class _ChangeableScheduleState extends State<ChangeableSchedule> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailySchedule>>(
      future: widget.schedule,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return DayItem(snapshot.data![index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
