import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/widgets/schedule/day_item.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:scientia/services/schedule_data/schedule_data.dart';

import '../../services/firestore_data.dart';


class WeeklySchedule extends StatefulWidget {
  var data = FirestoreData();
  List firstWeekSchedule;
  WeeklySchedule(this.firstWeekSchedule, {super.key});

  @override
  State<WeeklySchedule> createState() => _WeeklyScheduleState();
}

class _WeeklyScheduleState extends State<WeeklySchedule> {
  PageController pageController = PageController(
      viewportFraction: 0.85,
  );

  var _currPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var days = widget.firstWeekSchedule;
    const int pageCount = 5;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 32, bottom: 8, left: 16),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Weekly Schedule',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            height: 320,
            child: PageView.builder(
              padEnds: false,
              controller: pageController,
              itemCount: pageCount,
              itemBuilder: (context, index) {
                bool isLastPage = index == pageCount - 1;
                EdgeInsets itemPadding = isLastPage
                    ? const EdgeInsets.only(right: 16) // Adjust the padding value as needed
                    : EdgeInsets.zero;
                return Padding(
                  padding: itemPadding,
                  child: DayItem(days[index]),
                );
              },
            ),
          ),
        ),
        DotsIndicator(
          dotsCount: pageCount,
          position: _currPageValue,
          decorator: DotsDecorator(
            activeColor: Colors.black,
            size: const Size.square(8.0),
            activeSize: const Size(16.0, 8.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ],
    );
  }
}
