import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/exams_model.dart'; // Import your ExamsModel

class Exams extends StatefulWidget {
  Exams({super.key});

  @override
  _ExamsState createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {
  final ExamsModel examsModel = ExamsModel();  // Create an instance of ExamsModel

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: examsModel.fetchExams(),  // Use fetchExams method
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
            child: Padding(
              padding: const EdgeInsets.only(top: 18, left: 24, bottom: 24, right: 24),
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),  // Add a separator
                itemBuilder: (context, index) {
                  final exam = snapshot.data![index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            exam['name'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600, height: 1),
                          ),
                          Spacer(),
                          Text(
                            exam['date'],  // Use formatted date here
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 3),
                        child: Text(
                          exam['room'],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500, height: 1, color: Colors.grey),
                        ),
                      ),
                      Text(
                        exam['desc'],
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16),
                      )
                    ],
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
