import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubstituteTeachers extends StatefulWidget {
  final CollectionReference substitutions;

  SubstituteTeachers(this.substitutions);

  @override
  _SubstituteTeachersState createState() => _SubstituteTeachersState();
}

class _SubstituteTeachersState extends State<SubstituteTeachers> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.substitutions.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
              streamSnapshot.data!.docs[index];

              // Convert Timestamp to DateTime
              DateTime date = (documentSnapshot['date'] as Timestamp).toDate();

              // Format DateTime to String
              String formattedDate = DateFormat('EEEE – kk:mm').format(date);


              return Padding(
                padding: EdgeInsets.only(left: 16,right: 16, top: 8, bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              documentSnapshot['subject'],
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                  fontSize: 16
                              ),
                            ),
                            Text(
                              documentSnapshot['substituted'],
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              ),
                            ),
                            Text(
                              documentSnapshot['substituter'],
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
          );
        } return Center(child: CircularProgressIndicator());
      },
    );
  }
}

