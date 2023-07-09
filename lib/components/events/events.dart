import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'event.dart';

class Events extends StatelessWidget {
  final List _events;

  const Events(this._events);

  @override
  Widget build(BuildContext context) {
    var eventsCount = _events.length > 3 ? 3 : _events.length;
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
                    // Handle button click to open events page
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
            padding: EdgeInsets.only(top: 8, bottom: 8),
            height: eventsCount * 97 + 16,
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
                    height: 1,
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
