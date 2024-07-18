import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeworkCard extends StatelessWidget {
  final List<Map<String, dynamic>> homework;

  HomeworkCard({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    return homework.isNotEmpty
        ? SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, left: 16, bottom: 16),
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
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          'Due to: ${homework[index]['date']}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  homework[index]['teacher'].toString(),
                  style: const TextStyle(
                      fontSize: 14, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 16),
                  child: Linkify(
                    onOpen: (link) async {
                      if (!await launchUrl(Uri.parse(link.url))) {
                        throw Exception('Could not launch ${link.url}');
                      }
                    },
                    text: homework[index]['task'],
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
    )
        : Center(
      child: Text(
        'There is no homework',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
