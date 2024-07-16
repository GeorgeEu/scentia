import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../views/events_page.dart';

class Events extends StatefulWidget {
  final Future<List<DocumentSnapshot>> events;

  const Events(this.events, {super.key});

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        children: [
          FutureBuilder<List<DocumentSnapshot>>(
            future: widget.events,
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                //final int itemCount = snapshot.data!.length > 3 ? 3 : snapshot.data!.length;
                return Row(
                  children: [
                    const Text(
                      'Events',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.zero),
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const EventsPage()
                        ));
                      },
                      child: const Text(
                        'Show More',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    )
                  ],
                );
              }
              return const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Events',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: widget.events,
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final int itemCount = snapshot.data!.length > 3 ? 3 : snapshot.data!.length;
                  return ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = snapshot.data![index];

                      // Convert Timestamp to DateTime
                      DateTime date = (documentSnapshot['date'] as Timestamp).toDate();

                      // Format DateTime to String
                      String formattedDate = DateFormat('EEEE – kk:mm').format(date);

                      return InkWell(
                        onTap: () {
                          showEventBottomSheet(
                              context,
                              documentSnapshot['name'],
                              documentSnapshot['address'],
                              documentSnapshot['desc'],
                              documentSnapshot['imageUrl'],
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
                                  documentSnapshot['imageUrl'],
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
                                      documentSnapshot['name'],
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      documentSnapshot['address'],
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
                  );
                }
                return const Center(child: Text('No events found.'));
              },
            ),
          ),
        ],
      ),
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
        });
  }
}
