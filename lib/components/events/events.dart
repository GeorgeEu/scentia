import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../pages/drawer_pages/events_page.dart';
import 'package:card_test/components/events/event.dart';

class Events extends StatelessWidget {
  final List _events;

  const Events(this._events);

  @override
  Widget build(BuildContext context) {
    var eventsCount = 3;
    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 32),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Among Weekly Events',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              const Spacer(),
              if (_events.length > 4) // Check if there are more than 3 events
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EventsPage()
                    ));
                  },
                  child: Row(
                    children: const [
                      Text(
                        'More',
                      ),
                      Icon(Icons.chevron_right_rounded),
                    ],
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
