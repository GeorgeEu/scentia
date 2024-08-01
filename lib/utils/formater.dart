import 'package:flutter/material.dart';

class Formater {
  static String shortWeekDayToLong(String abbreviatedDay) {
    switch (abbreviatedDay.toUpperCase()) {
      case 'MON':
        return 'Monday';
      case 'TUE':
        return 'Tuesday';
      case 'WED':
        return 'Wednesday';
      case 'THU':
        return 'Thursday';
      case 'FRI':
        return 'Friday';
      case 'SAT':
        return 'Saturday';
      case 'SUN':
        return 'Sunday';
      default:
        return abbreviatedDay; // Return the abbreviated day if not found
    }
  }

  static dynamic gradeToColor(int grade) {
    switch (grade) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
        return Colors.grey;
      case 7:
      case 8:
      case 9:
        return Colors.green;
      case 10:
        return const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return Colors.black; // Return a default color if grade is out of expected range
    }
  }


  static dynamic percentToColor(double percent) {
    const Color color1 = Color(0xFF009245);
    const Color color2 = Color(0xFFFCEE21);
    if (percent >= 0 && percent <= 5) {
      return const LinearGradient(
        colors: [color2, color1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return Colors.grey;
    }
  }


}
