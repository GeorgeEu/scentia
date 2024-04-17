import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/firestore_data.dart';

class ScheduleTest extends StatefulWidget {
  ScheduleTest({super.key});

  @override
  _ScheduleTestState createState() => _ScheduleTestState();
}

class _ScheduleTestState extends State<ScheduleTest> {
  var data = FirestoreData();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: FutureBuilder<List<DocumentSnapshot>>(
        future: data.getWeek(),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data available"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              DocumentSnapshot day = snapshot.data![index];
              var data = day.data() as Map<String, dynamic>?;

              List<dynamic> lessons = [];
              if (data != null && data['lessons'] is List) {
                lessons = data['lessons'];
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(day['name']), // we can just use it here this way. As I said no need to declare it before.
                    if (lessons.isNotEmpty)
                      ...lessons.map((lesson) =>
                          Text(lesson is Map<String, dynamic> ? lesson['end']?.toString() ?? 'Unknown title' : lesson.toString())).toList()
                    else
                      Text("No lessons"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
