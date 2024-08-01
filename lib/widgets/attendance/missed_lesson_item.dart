import 'package:flutter/material.dart';

import '../../utils/formater.dart';

class MissedLessonItem extends StatelessWidget {
  final String subject;
  final double percentage;

  MissedLessonItem({required this.subject, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final specialColor = Formater.percentToColor(percentage);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        height: 48,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              subject,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            Spacer(),
            Container(
              width: 29,
              height: 29,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: specialColor is LinearGradient ? specialColor : null,
                color: specialColor is Color ? specialColor : null,

              ),
              alignment: Alignment.center,
              child: Text(
                '${percentage.round()}%',
                style: TextStyle(
                  fontSize: 15,
                  height: 1,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
