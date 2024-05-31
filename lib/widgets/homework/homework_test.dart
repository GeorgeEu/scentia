import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeworkTest extends StatefulWidget {
  final data = FirestoreData();

  HomeworkTest({super.key});

  @override
  State<HomeworkTest> createState() => _HomeworkTestState();
}

class _HomeworkTestState extends State<HomeworkTest> {
  List<Map<String, dynamic>> homeworkItems = []; // A list to store grade details
  bool isLoading = true; // Added flag to track loading state

  @override
  void initState() {
    super.initState();
    homework();
  }

  void homework() async {
    if (!mounted) return; // Add this line to check if the widget is still mounted
    setState(() {
      isLoading = true; // Set loading to true when starting to fetch data
    });

    DocumentReference user = FirebaseFirestore.instance.collection('users').doc('Tb3HelcRbnQZcxHok9l4YI5pwwI3');

    List<DocumentSnapshot> homework = await widget.data.getHomework(user);
    List<Map<String, dynamic>> tempHomework = [];
    for (var task in homework) {
      var homeworkData = task.data() as Map<String, dynamic>;
      DocumentSnapshot subjectDoc = await widget.data.getDoc(task['subject']);
      DocumentSnapshot teacherDoc = await widget.data.getDoc(task['teacher']);
      String subjectName = subjectDoc['name']; // Adjust this field based on your Firestore structure
      String teacherName = teacherDoc['name']; // Adjust this field based on your Firestore structure
      DateTime date = (homeworkData['endAt'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);
      tempHomework.add({
        'task': homeworkData['task'],
        'subject': subjectName,
        'teacher': teacherName,
        'date': formattedDate,
      });
    }
    if (!mounted) return; // Check again before calling setState
    setState(() {
      homeworkItems = tempHomework;
      isLoading = false; // Set loading to false after data is fetched
    });
  }

  // Future<void> _onOpen(LinkableElement link) async {
  //   if (await canLaunch(link.url)) {
  //     await launch(link.url);
  //   } else {
  //     print('Could not launch $link');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator while data is being fetched
      return const Center(child: CircularProgressIndicator());
    }

    // Render the list view once the data is fetched
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: homeworkItems.length < 3 ? homeworkItems.length : 2,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    homeworkItems[index]['subject'],
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    'Due to: ${homeworkItems[index]['date']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Text(
              homeworkItems[index]['teacher'].toString(),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4, right: 16),
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
                  decorationColor: Colors.blue
                ),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(thickness: 0.5); // This is the separator widget
      },
    );
  }
}
