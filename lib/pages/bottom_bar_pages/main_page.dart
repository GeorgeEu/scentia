import 'package:card_test/components/events/events.dart';
import 'package:card_test/components/schedule/weakly_schedule.dart';
import 'package:flutter/material.dart';
import 'package:card_test/data/events_data/events_data.dart';
import 'package:card_test/components/navigation_drawer.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);

  @override
  State<Main_Page> createState() => _MainPageState();
}

class _MainPageState extends State<Main_Page> {
  var events = EventsData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu_rounded),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
          elevation: 0,
          backgroundColor: const Color(0xffefeff4),
          title: const Text("11A, American International School Progress"),
        ),
        drawer: MyDrawer(),
        body: Container(
          color: const Color(0xffefeff4),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(children: [
              const WeeklySchedule(),
              Events(events.getEvents()),
            ]),
          ),
        ));
  }
}
