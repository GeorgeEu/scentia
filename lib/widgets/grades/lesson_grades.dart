import 'package:flutter/material.dart';
import 'package:scientia/utils/formater.dart';
import 'package:scientia/widgets/empty_state_page.dart';

class LessonGrades extends StatelessWidget {
  final List<Map<String, dynamic>> allGrades;

  LessonGrades({super.key, required this.allGrades});

  @override
  Widget build(BuildContext context) {
    return allGrades.isNotEmpty
        ? SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
        child: ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: allGrades.length,
          itemBuilder: (context, index) {
            var subjectGradesMap = allGrades[index];
            List<Map<String, dynamic>> grades = subjectGradesMap['Grades'];
            double meanGrade = subjectGradesMap['meanGrade'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      subjectGradesMap['subjectName'],
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        meanGrade.toStringAsFixed(2),
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w600, height: 1),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, top: 3),
                  child: Text(
                    subjectGradesMap['teacher'],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal,color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: grades.map<Widget>((grade) {
                      final gradeValue = grade['grade'];
                      final colorOrGradient = Formater.gradeToColor(gradeValue); // Using the utility function
                      return Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorOrGradient is Color ? colorOrGradient : null,
                          gradient: colorOrGradient is LinearGradient ? colorOrGradient : null,
                        ),
                        child: Text(
                          gradeValue.toString(),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => Divider(thickness: 0.5),
        ),
      ),
    )
        : Center(
      child: EmptyStatePage(
        message: "You haven't got any grades yet",
      ),
    );
  }
}
