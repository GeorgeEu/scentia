import 'package:card_test/components/events/events.dart';
import 'package:card_test/components/schedule/weakly_schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_test/data/events_data/events_data.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);

  @override
  State<Main_Page> createState() => _MainPageState();
}

class _MainPageState extends State<Main_Page> {
  var events = EventsData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffefeff4),
          title: const Text("11A, American International School Progress"),
        ),
        body: Container(
          color: const Color(0xffefeff4),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  const WeeklySchedule(),
                  Events(events.getEvents()),
                ]
            ),
          ),
        )
    );
  }
}