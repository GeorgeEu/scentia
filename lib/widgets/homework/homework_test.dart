import 'package:flutter/material.dart';
import 'package:scientia/widgets/empty_state_widget.dart';
import '../../models/expandable_text.dart';

class HomeworkTest extends StatelessWidget {
  final List<Map<String, dynamic>> homework;

  HomeworkTest({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    return homework.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListView.separated(
        primary: false,
        shrinkWrap: true,
        itemCount: homework.length < 3 ? homework.length : 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 4.0 : 0.0, // Add padding only for the first item
              bottom: index == (homework.length < 3 ? homework.length - 1 : 1) ? 6.0 : 0.0, // Add padding only for the last item
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        homework[index]['subject'],
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        'Due to: ${homework[index]['date']}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                Text(
                  homework[index]['teacher'].toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, right: 16),
                  child: ExpandableText(
                    text: homework[index]['task'],
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    linkStyle: const TextStyle(
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
                    maxLines: 4,
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
        : const SizedBox(
      height: 186,
      child: EmptyStateWidget(
        message: 'There is no homework yet',
      ),
    );
  }
}
