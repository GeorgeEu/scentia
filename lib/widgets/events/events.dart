import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/widgets/st_row.dart';
import '../../views/events_page.dart';
import '../st_chevron_right.dart';
import '../st_header.dart';

class Events extends StatefulWidget {
  final List<DocumentSnapshot> events;

  const Events({super.key, required this.events});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StRow(
          stHeader: StHeader(text: 'Events'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EventsPage(events: widget.events))
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EventsPage(events: widget.events))
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: widget.events.isNotEmpty
                ? ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: widget.events.length > 3 ? 3 : widget.events.length,
              itemBuilder: (context, index) {
                final event = widget.events[index];

                // Convert Timestamp to DateTime
                DateTime date = (event['date'] as Timestamp).toDate();

                // Format DateTime to String
                String formattedDate = DateFormat('EEEE – kk:mm').format(date);

                return InkWell(
                  onTap: () {
                    showEventBottomSheet(
                        context,
                        event['name'],
                        event['address'],
                        event['desc'],
                        event['imageUrl'],
                        formattedDate);
                  },
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            event['imageUrl'],
                            // Use the image URL from Firestore
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('Image not available'); // Error text if image fails to load
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                    fontSize: 15),
                              ),
                              Text(
                                event['name'],
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                              Text(
                                event['address'],
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 0.5,
                  indent: 104,
                ); // Your separator widget
              },
            )
                : const Center(
              child: Text('No events found.'),
            ),
          ),
        ),
      ],
    );
  }

  void showEventBottomSheet(BuildContext context, String name, String address,
      String desc, String imageUrl, String formattedDate) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 350,
                  height: 216,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      // Use the image URL from Firestore
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Image not available'); // Error text if image fails to load
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontSize: 15),
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    address,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                      fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
