import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import intl package

class Exams extends StatefulWidget {
  final Future<List<DocumentSnapshot>> exams;
  Exams(this.exams);

  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.exams,
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot exam =
                  snapshot.data![index];
            
                  // Convert Timestamp to DateTime
                  DateTime date = (exam['date'] as Timestamp).toDate();
            
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
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              exam['name'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              exam['room'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              exam['desc'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return Center(
          child: Text('No exams found.'),
        );
      },
    );
  }
}
