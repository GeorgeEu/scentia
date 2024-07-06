import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/firestore_data.dart';
import '../../services/subject_services.dart';
import '../../utils/formater.dart';


class DailyGradesTest extends StatefulWidget {
  final data = FirestoreData();

  DailyGradesTest({super.key});

  @override
  State<DailyGradesTest> createState() => _DailyGradesTestState();
}

class _DailyGradesTestState extends State<DailyGradesTest> {
  SubjectServices subjects = SubjectServices();
  List<Map<String, dynamic>> gradeItems = []; // A list to store grade details
  bool isLoading = true; // Added flag to track loading state

  @override
  void initState() {
    super.initState();
    subjects.initialize();
    grades();
  }

  void grades() async {
    if (!mounted) return; // Add this line to check if the widget is still mounted
    setState(() {
      isLoading = true; // Set loading to true when starting to fetch data
    });
    List<DocumentSnapshot> grades = await widget.data.getGrades('Tb3HelcRbnQZcxHok9l4YI5pwwI3');
    List<Map<String, dynamic>> tempGradeItems = [];
    for (var grade in grades) {
      var gradeData = grade.data() as Map<String, dynamic>;
      String subjectName = await subjects.getSubjectById(gradeData['sid']);
      DateTime date = (gradeData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MMM d').format(date);
      tempGradeItems.add({
        'grade': gradeData['grade'],
        'subject': subjectName,
        'teacher': gradeData['teacher'],
        'date': formattedDate,
      });
    }
    if (!mounted) return; // Check again before calling setState
    setState(() {
      gradeItems = tempGradeItems;
      isLoading = false; // Set loading to false after data is fetched
    });
  }

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
      itemCount: gradeItems.length < 4 ? gradeItems.length : 4,
      itemBuilder: (context, index) {
        final gradeValue = gradeItems[index]['grade'];
        final specialColor = Formater.gradeToColor(gradeValue); // Using the utility function

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    gradeItems[index]['subject'],
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    gradeItems[index]['date'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  gradeItems[index]['teacher'].toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, right: 16),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: specialColor is Color ? specialColor : null,
                      gradient: specialColor is LinearGradient ? specialColor : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      gradeValue.toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
              ],
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
