import 'package:flutter/material.dart';
import 'package:scientia/services/firestore_data.dart';
import '../../services/subject_services.dart';
import '../../utils/formater.dart';

class DailyGradesTest extends StatefulWidget {
  final data = FirestoreData();
  final List<Map<String, dynamic>> gradeItems;

  DailyGradesTest({super.key, required this.gradeItems});

  @override
  State<DailyGradesTest> createState() => _DailyGradesTestState();
}

class _DailyGradesTestState extends State<DailyGradesTest> {
  SubjectServices subjects = SubjectServices();



  @override
  Widget build(BuildContext context) {
    // Render the list view once the data is fetched
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: widget.gradeItems.length < 4 ? widget.gradeItems.length : 4,
      itemBuilder: (context, index) {
        final gradeValue = widget.gradeItems[index]['grade'];
        final specialColor = Formater.gradeToColor(gradeValue); // Using the utility function
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.gradeItems[index]['subject'],
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    widget.gradeItems[index]['date'],
                    style: const TextStyle(fontSize: 14.5, color: Colors.grey, height: 1),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 2),
              child: Row(
                children: [
                  Text(
                    widget.gradeItems[index]['teacher'].toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
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
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13, height: 1),
                      ),
                    ),
                  ),
                ],
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
