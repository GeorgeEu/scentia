import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../pages/drawer_pages/events_page.dart';
import 'package:scientia/components/events/event.dart';

class Events extends StatelessWidget {
  final List _events;

  const Events(this._events);

  @override
  Widget build(BuildContext context) {
    var eventsCount = 3;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Events',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                ),
              ),
              const Spacer(),
              if (_events.length > 4) // Check if there are more than 3 events
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EventsPage()
                    ));
                  },
                  child: Text(
                    'Show More',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
            ],
          ),
          Container(
            height: eventsCount * 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: eventsCount,
              itemBuilder: (context, index) {
                return Event(_events[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                    thickness: 0.5,
                    height: 16,
                    indent: 112.0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
