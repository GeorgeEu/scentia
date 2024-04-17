import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// StatefulWidget
class FullEvents extends StatefulWidget {
  final CollectionReference events;

  FullEvents(this.events);

  @override
  _FullEventsState createState() => _FullEventsState();
}

// State for FullEvents
class _FullEventsState extends State<FullEvents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12),
      child: FutureBuilder<QuerySnapshot>(
          future: widget.events.get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  snapshot.data!.docs[index];

                  // Convert Timestamp to DateTime
                  DateTime date =
                      (documentSnapshot['date'] as Timestamp).toDate();

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
                        formattedDate
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 8, top: 4),
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
                                  return Text(
                                      'Image not available'); // Error text if image fails to load
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(left: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                      fontSize: 15),
                                ),
                                Text(
                                  documentSnapshot['name'],
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                Text(
                                  documentSnapshot['address'],
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(); // Your separator widget
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
  void showEventBottomSheet(BuildContext context, String name, String address, String desc, String imageUrl, String formattedDate) {
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
              padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
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
                          return Text(
                              'Image not available'); // Error text if image fails to load
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      address,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),
                    ),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
