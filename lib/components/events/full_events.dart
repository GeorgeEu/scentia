import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../pages/drawer_pages/events_page.dart';
import 'package:card_test/components/events/event.dart';

import 'full_event.dart';

class FullEvents extends StatelessWidget {
  final List _events;

  const FullEvents(this._events);

  @override
  Widget build(BuildContext context) {
    var eventsCount = _events.length;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Column(
        children: [
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: eventsCount,
            itemBuilder: (context, index) {
              return FullEvent(_events[index]);
            },
          ),
          // ListView.separated(
          //   primary: false,
          //   shrinkWrap: true,
          //   itemCount: eventsCount,
          //   itemBuilder: (context, index) {
          //     return FullEvent(_events[index]);
          //   },
          //   separatorBuilder: (context, index) {
          //     return const Divider(
          //       thickness: 0.5,
          //       height: 1,
          //       indent: 112.0,
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
