import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scientia/widgets/schedule/my_date_picker.dart';

import '../models/daily_schedule.dart';
import '../services/schedule_service.dart';
import '../widgets/schedule/changeable_schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin {
  late ScheduleService scheduleService;
  late Future<List<DailySchedule>> schedule;
  late TabController _tabController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize with the current date
    selectedDate = DateTime.now();
    final Timestamp currTimestamp = Timestamp.fromDate(selectedDate);

    // Initialize the ScheduleService with the current timestamp
    scheduleService = ScheduleService(cls: '12b', timestamp: currTimestamp);
    schedule = scheduleService.getWeeklySchedule();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      final Timestamp newTimestamp = Timestamp.fromDate(date);
      scheduleService = ScheduleService(cls: '12b', timestamp: newTimestamp);
      schedule = scheduleService.getWeeklySchedule();
      // Switch back to the first tab (schedule tab)
      _tabController.animateTo(0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFA4A4FF),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
          title: Text(
            'Schedule',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.white, // Color of the selected tab text
            unselectedLabelColor: Colors.black54, // Color of the unselected tab text
            controller: _tabController,
            tabs: [
              Tab(text: "Latest"),
              Tab(text: "Future"),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFF3F2F8),
        body: TabBarView(
          controller: _tabController,
          children: [
            ChangeableSchedule(schedule),
            MyDatePicker(onDateSelected: _onDateSelected),
          ],
        ),
      ),
    );
  }
}
