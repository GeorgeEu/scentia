import 'package:scientia/widgets/events/full_events.dart';
import 'package:flutter/material.dart';
import 'package:scientia/services/firestore_data.dart';
import '../services/auth_services.dart';

class EventsPage extends StatefulWidget {
  final List<Map<String, dynamic>> events;
  EventsPage({super.key, required this.events});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String? userId = AuthService.getCurrentUserId();
  var data = FirestoreData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefeff4),
      appBar: AppBar(
        backgroundColor: Color(0xFFA4A4FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              // showSearch(context: context, delegate: );
            },
          )
        ],
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(
          'Events',
          style: TextStyle(
            fontWeight: FontWeight.w500,
              color: Colors.white
          ),
        ),
        // titleSpacing: 0,
      ),
      body: FullEvents(events: widget.events)
    );
  }
}

