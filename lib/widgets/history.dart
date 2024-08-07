import 'package:flutter/material.dart';
import 'package:scientia/views/history_page.dart';
import 'package:scientia/widgets/st_chevron_right.dart';
import 'package:scientia/widgets/st_header.dart';
import 'package:scientia/widgets/st_row.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StRow(
          stHeader: StHeader(text: 'History'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HistoryPage())
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HistoryPage())
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Container(),
          ),
        )
      ],
    );
  }
}
