import 'package:scientia/components/events/full_events.dart';
import 'package:flutter/material.dart';
import 'package:scientia/data/firestore_data.dart';

import '../../data/events_data/events_data.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  var data = FirestoreData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefeff4),
      appBar: AppBar(
        backgroundColor: Color(0xFFADADFF),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              // showSearch(context: context, delegate: );
            },
          )
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.w500,
              color: Colors.white
          ),
        ),
        // titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: FullEvents(data.getEvents()),
      )
    );
  }
}

