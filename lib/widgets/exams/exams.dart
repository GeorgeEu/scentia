import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import intl package

class Exams extends StatefulWidget {
  final CollectionReference exams;
  Exams(this.exams);

  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.exams.get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                snapshot.data!.docs[index];

                // Convert Timestamp to DateTime
                DateTime date = (documentSnapshot['date'] as Timestamp).toDate();

                // Format DateTime to String
                String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(date);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,  // Use formatted date here
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            documentSnapshot['name'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            documentSnapshot['room'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            documentSnapshot['desc'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
