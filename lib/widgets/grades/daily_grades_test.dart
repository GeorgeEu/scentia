import 'package:flutter/material.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/widgets/empty_state_widget.dart';
import '../../utils/formater.dart';

class DailyGradesTest extends StatefulWidget {
  final data = FirestoreData();
  final List<Map<String, dynamic>> gradeItems;

  DailyGradesTest({super.key, required this.gradeItems});

  @override
  State<DailyGradesTest> createState() => _DailyGradesTestState();
}

class _DailyGradesTestState extends State<DailyGradesTest> {

  @override
  Widget build(BuildContext context) {
    return widget.gradeItems.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: widget.gradeItems.length < 4 ? widget.gradeItems.length : 4,
        itemBuilder: (context, index) {
          final gradeValue = widget.gradeItems[index]['grade'];
          final specialColor = Formater.gradeToColor(gradeValue); // Using the utility function
          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 12.0 : 0.0, // Add padding only for the first item
              bottom: index == (widget.gradeItems.length < 4 ? widget.gradeItems.length - 1 : 3) ? 12.0 : 0.0, // Add padding only for the last item
            ),
            child: Column(
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
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(thickness: 0.5); // This is the separator widget
        },
      ),
    )
        : SizedBox(
      height: 186,
      width: double.infinity,
      child: EmptyStateWidget(
        size: 95,
        path: 'assets/dayns.png',
        message: 'There are no grades yet',
      ),
    );
  }
}
