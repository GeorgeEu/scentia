import 'package:card_test/components/schedule/day_item.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:card_test/data/schedule_data/schedule_data.dart';


class WeeklySchedule extends StatefulWidget {
  const WeeklySchedule({Key? key}) : super(key: key);

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
    const int pageCount = 5;

    return Column(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            padEnds: false,
            controller: pageController,
            itemCount: pageCount,
            itemBuilder: (context, position) {
              // Check if it's the last index
              bool isLastPage = position == pageCount - 1;

              return IndexedStack(
                index: isLastPage ? 1 : 0,
                children: [
                  // Page content with safe area
                  _buildScheduleItem(position),
                  // Last page with padding
                  if (isLastPage)
                    Container(
                      padding: EdgeInsets.only(right: 16),
                      child: SafeArea(
                        child: _buildScheduleItem(position),
                      ),
                    ),
                ],
              );
            },
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
  Widget _buildScheduleItem(int index){
    var lessons = ScheduleData();
    var days = lessons.getSchedule();
    return DayItem(days[index]);
  }
}
