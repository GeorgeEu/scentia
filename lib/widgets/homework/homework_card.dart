import 'package:flutter/material.dart';
import 'package:scientia/models/expandable_text.dart';
import 'package:scientia/widgets/empty_state_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeworkCard extends StatelessWidget {
  final List<Map<String, dynamic>> homework;

  HomeworkCard({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    return homework.isNotEmpty
        ? SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 24, bottom: 24, right: 24),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: homework.length,
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
                        homework[index]['subject'],
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600, height: 1),
                      ),
                      const Spacer(),
                      Text(
                        'Due to: ${homework[index]['date']}',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey, height: 1),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 2),
                  child: Text(
                    homework[index]['teacher'].toString(),
                    style: const TextStyle(
                        fontSize: 14, color: Colors.grey, height: 1),
                  ),
                ),
                ExpandableText(
                  text: homework[index]['task'],
                  linkStyle: const TextStyle(
                      color: Colors.blue, // Customize the link color if needed
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ), maxLines: 5,
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 8,
            ); // This is the separator widget
          },
        ),
      ),
    )
        : Center(
      child: EmptyStatePage(
        message: 'There is no homework',
      ),
    );
  }
}
