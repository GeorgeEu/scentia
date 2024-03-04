import 'package:intl/intl.dart';

class AttendanceData {
  final _attendance = [
    {
      "Date": 1693530061000, // September 1, 2023
      "Lesson": "History",
      "Absence": 1,
      "Late": 0
    },
    {
      "Date": 1693616461000, // September 2, 2023
      "Lesson": "Geography",
      "Absence": 0,
      "Late": 1
    },
    {
      "Date": 1693702861000, // September 3, 2023
      "Lesson": "English",
      "Absence": 2,
      "Late": 0
    },
    {
      "Date": 1696122061000, // October 1, 2023
      "Lesson": "Math",
      "Late": 2,
      "Absence": 1
    },
    {
      "Date": 1696208461000, // October 2, 2023
      "Lesson": "Science",
      "Late": 0,
      "Absence": 1
    },
    {
      "Date": 1696294861000, // October 3, 2023
      "Lesson": "History",
      "Late": 1,
      "Absence": 0
    },
    {
      "Date": 1698800461000, // November 1, 2023
      "Lesson": "Geography",
      "Absence": 1,
      "Late": 0
    },
    {
      "Date": 1698886861000, // November 2, 2023
      "Lesson": "English",
      "Absence": 0,
      "Late": 1
    },
    {
      "Date": 1698973261000, // November 3, 2023
      "Lesson": "Math",
      "Absence": 2,
      "Late": 2
    },
    {
      "Date": 1701392461000, // December 1, 2023
      "Lesson": "Science",
      "Late": 3,
      "Absence": 0
    },
    {
      "Date": 1701478861000, // December 2, 2023
      "Lesson": "History",
      "Late": 1,
      "Absence": 1
    },
    {
      "Date": 1701565261000, // December 3, 2023
      "Lesson": "Geography",
      "Late": 2,
      "Absence": 0
    },
    {
      "Date": 1704070861000, // January 1, 2024
      "Lesson": "English",
      "Absence": 0,
      "Late": 2
    },
    {
      "Date": 1704157261000, // January 2, 2024
      "Lesson": "Math",
      "Absence": 1,
      "Late": 0
    },
    {
      "Date": 1704243661000, // January 3, 2024
      "Lesson": "Science",
      "Absence": 0,
      "Late": 1
    },
    {
      "Date": 1706749261000, // February 1, 2024
      "Lesson": "History",
      "Absence": 1,
      "Late": 1
    },
    {
      "Date": 1706922061000, // February 3, 2024
      "Lesson": "Geography",
      "Absence": 2,
      "Late": 2
    },
    {
      "Date": 1688223600000, // March 1, 2024
      "Lesson": "English",
      "Absence": 1,
      "Late": 0
    },
    {
      "Date": 1709341261000, // March 2, 2024
      "Lesson": "Math",
      "Absence": 0,
      "Late": 1
    },
    {
      "Date": 1709427661000, // March 3, 2024
      "Lesson": "Science",
      "Absence": 3,
      "Late": 3
    },
    {
      "Date": 1711933261000, // April 1, 2024
      "Lesson": "History",
      "Absence": 2,
      "Late": 2
    },
    {
      "Date": 1712019661000, // April 2, 2024
      "Lesson": "Geography",
      "Absence": 0,
      "Late": 1
    },
    {
      "Date": 1712106061000, // April 3, 2024
      "Lesson": "English",
      "Absence": 1,
      "Late": 0
    },
    {
      "Date": 1714525261000, // May 1, 2024
      "Lesson": "Math",
      "Absence": 1,
      "Late": 1
    },
    {
      "Date": 1714611661000, // May 2, 2024
      "Lesson": "Science",
      "Absence": 0,
      "Late": 2
    },
    {
      "Date": 1714698061000, // May 3, 2024
      "Lesson": "History",
      "Absence": 1,
      "Late": 0
    },
    {
      "Date": 1717203661, // June 1, 2024
      "Lesson": "Geography",
      "Absence": 2,
      "Late": 0
    },
    {
      "Date": 1717290061, // June 2, 2024
      "Lesson": "English",
      "Absence": 0,
      "Late": 1
    },
    {
      "Date": 1717376461, // June 3, 2024
      "Lesson": "Math",
      "Absence": 1,
      "Late": 2
    }
  ];


  String convertTimestampToMonth(int timestamp) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String fdatetime = DateFormat('MMMM').format(
        tsdate); // Corrected the format string to 'yyyy'
    // print(fdatetime);
    return fdatetime;
  }

  List getAttendance() {
    return _attendance;
  }


  List getDailyAttendance(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOftDay = day.millisecondsSinceEpoch;
    final endOfDay = beginOftDay + 24 * 60 * 60 * 1000 - 1;
    List rawAttendance = getAttendance();
    List attendance = [];
    for (var i = 0; i < rawAttendance.length; i++) {
      if (rawAttendance[i]['Date'] < beginOftDay) continue;
      if (rawAttendance[i]['Date'] > endOfDay) continue;
      attendance.add(rawAttendance[i]);
    }
    return attendance;
  }

  Map<String, dynamic> getMonthlyAttendance(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOfMonth = day.millisecondsSinceEpoch;
    final endOfMonth = beginOfMonth + 30 * 24 * 60 * 60 * 1000;
    //final endOfMonth = DateTime(date.year, date.month + 1, 0).millisecondsSinceEpoch;
    Map<String, dynamic> monthlyAttendance;
    int absences = 0;
    int lates = 0;
    for (var t = beginOfMonth; t < endOfMonth; t = t + 24 * 60 * 60 * 1000) {
      List day = getDailyAttendance(t);
      if (day.isNotEmpty) {
        final int? absence = day[0]['Absence'];
        absences = absences + absence!;
        final int? late = day[0]['Late'];
        lates = lates + late!;
      }
    }
    monthlyAttendance = {
      "month": convertTimestampToMonth(beginOfMonth),
      "absences": absences,
      "lates": lates
    };
    return monthlyAttendance;
  }

  List getSemesterAttendance() {
    final startingTimestamp = 1693530061000;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(startingTimestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOfSemester = day.millisecondsSinceEpoch;
    final endOfSemester = beginOfSemester + 9 * 30 * 24 * 60 * 60 * 1000;
    List months = [];
    for (
      var t = beginOfSemester;
      t < endOfSemester;
      t = t + 30 * 24 * 60 * 60 * 1000
    ) {
      months.add(getMonthlyAttendance(t));
    }
    return months;
  }

  Map<String, dynamic> getAllAttendance(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOfSemester = day.millisecondsSinceEpoch;
    final endOfSemester = beginOfSemester + 10 * 30 * 24 * 60 * 60 * 1000;
    //final endOfMonth = DateTime(date.year, date.month + 1, 0).millisecondsSinceEpoch;
    Map<String, dynamic> allAttendance;
    int absences = 0;
    int lates = 0;
    for (var t = beginOfSemester; t < endOfSemester; t = t + 24 * 60 * 60 * 1000) {
      List day = getDailyAttendance(t);
      if (day.isNotEmpty) {
        final int? absence = day[0]['Absence'];
        absences = absences + absence!;
        final int? late = day[0]['Late'];
        lates = lates + late!;
      }
    }
    allAttendance = {
      "absences": absences,
      "lates": lates
    };
    return allAttendance;
  }
}
