import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/homework_model.dart';

class HomeworkCard extends StatelessWidget {
  final HomeworkModel homeworkModel = HomeworkModel();

  HomeworkCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: homeworkModel.fetchHomework(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'There is no homework',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600),
            ),
          );
        } else {
          final homeworkItems = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, left: 16, bottom: 16),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                itemCount: homeworkItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Text(
                              homeworkItems[index]['subject'],
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                'Due to: ${homeworkItems[index]['date']}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        homeworkItems[index]['teacher'].toString(),
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, right: 16),
                        child: Linkify(
                          onOpen: (link) async {
                            if (!await launchUrl(Uri.parse(link.url))) {
                              throw Exception('Could not launch ${link.url}');
                            }
                          },
                          text: homeworkItems[index]['task'],
                          linkStyle: const TextStyle(
                              color: Colors.blue, // Customize the link color if needed
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 0.5,
                    height: 0,
                  ); // This is the separator widget
                },
              ),
            ),
          );
        }
      },
    );
  }
}
