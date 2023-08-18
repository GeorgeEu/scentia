import 'package:intl/intl.dart';

class AttendanceData {
  final _attendance = [
    {
      "Date": 1630453200000, // September 1, 2021
      "Absence": 1,
      "Late": 1
    },
    {
      "Date": 1633131600000, // October 1, 2021
      "Late": 2,
      'Absence': 0
    },
    {
      "Date": 1635723600000, // November 1, 2021
      "Absence": 2,
      'Late': 0
    },
    {
      "Date": 1638402000000, // December 1, 2021
      "Absence": 1,
      "Late": 3
    },
    {
      "Date": 1641080400000, // January 1, 2022
      "Late": 1,
      "Absence": 0
    },
    {
      "Date": 1643758800000, // February 1, 2022
      "Absence": 1,
      "Late": 0
    },
    {
      "Date": 1646178000000, // March 1, 2022
      "Absence": 40,
      "Late": 2
    },
    {
      "Date": 1648856400000, // April 1, 2022
      "Late": 1,
      "Absence": 2
    },
    {
      "Date": 1651448400000, // May 1, 2022
      "Absence": 1,
      "Late": 1
    },
    {
      "Date": 1654126800000, // June 1, 2022
      "Absence": 2,
      "Late": 0
    },
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
    final startingTimestamp = 1630453200000;
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
