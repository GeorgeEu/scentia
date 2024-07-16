import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubstituteTeachers extends StatefulWidget {
  final Future<List<DocumentSnapshot>> substitutions;

  const SubstituteTeachers(this.substitutions, {super.key});

  @override
  _SubstituteTeachersState createState() => _SubstituteTeachersState();
}

class _SubstituteTeachersState extends State<SubstituteTeachers> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.substitutions,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot substituter = snapshot.data![index];

              // Convert Timestamp to DateTime
              DateTime date = (substituter['date'] as Timestamp).toDate();

              // Format DateTime to String
              String formattedDate = DateFormat('EEEE – kk:mm').format(date);

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              substituter['subject'],
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              substituter['substituted'],
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              substituter['substituter'],
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
          );
        }
        return Center(child: Text('No substitutions found.'));
      },
    );
  }
}
