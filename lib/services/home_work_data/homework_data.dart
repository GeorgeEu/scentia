import 'package:intl/intl.dart';

class HomeworkData {
  final _homework = [
    {
      "Date": 1693768237000,  // September 3, 2023
      "Name": "Chemistry",
      "Task": "Alkanes (15-20)",
    },
    {
      "Date": 1693846800000,  // September 4, 2023
      "Name": "Biology",
      "Task": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    },
    {
      "Date": 1693846800000,  // September 4, 2023
      "Name": "Geography",
      "Task": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    },
    {
      "Date": 1693933200000,  // September 5, 2023
      "Name": "IELTS",
      "Task": "Part number 7",
    },
    {
      "Date": 1693933200000,  // September 5, 2023
      "Name": "SAT",
      "Task": "Check Khan Academy",
    },
    {
      "Date": 1693933200000,  // September 5, 2023
      "Name": "Biology",
      "Task": "Presentation",
    },
    {
      "Date": 1693933200000,  // September 5, 2023
      "Name": "Geography",
      "Task": "bla-bla-bla",
    },
    {
      "Date": 1694019600000,  // September 6, 2023
      "Name": "IELTS",
      "Task": "Modal Verbs",
    },
    {
      "Date": 1694106000000,  // September 7, 2023
      "Name": "SAT",
      "Task": "Lorem ipsum dolor sit",
    },
    {
      "Date": 1694019600000,  // September 6, 2023
      "Name": "Math",
      "Task": "Make a project about math",
    },
    {
      "Date": 1694106000000,  // September 7, 2023
      "Name": "American History",
      "Task": "Slavery",
    },
    {
      "Date": 1694192400000,  // September 8, 2023
      "Name": "Math",
      "Task": "Page (110 - 120)",
    },
    {
      "Date": 1694106000000,  // September 7, 2023
      "Name": "Chemistry",
      "Task": "Revision of all alkanes",
    },
    {
      "Date": 1694192400000,  // September 8, 2023
      "Name": "SAT",
      "Task": "Finish ex. homework",
    },
    {
      "Date": 1694192400000,  // September 8, 2023
      "Name": "American History",
      "Task": "Industrial Revolution",
    },
    {
      "Date": 1694192400000,  // September 8, 2023
      "Name": "Chemistry",
      "Task": "Revision",
    },
    {
      "Date": 1693104000000,  // aug 27, 2023
      "Name": "Check",
      "Task": "Lorem Ipsum Dolor Sit Amet",
    },
  ];


  String convertTimestampToDayOfWeek(int timestamp) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String fdatetime = DateFormat('EEEE').format(tsdate); // Corrected the format string to 'yyyy'
    return fdatetime;
  }

  List getHomework() {
    return _homework;
  }

  List getDailyHomework(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOftDay = day.millisecondsSinceEpoch;
    final endOfDay = beginOftDay + 24 * 60 * 60 * 1000 - 1;
    List rawHomework = getHomework();
    List homework = [];
    for (var i = 0; i < rawHomework.length; i++) {
      if (rawHomework[i]['Date'] < beginOftDay) continue;
      if (rawHomework[i]['Date'] > endOfDay) continue;
      homework.add(rawHomework[i]);
    }
    return homework;
  }
  // FROM ABOVE We get daily homework FROM BELOW We get weekly homework
  List getWeeklyHomework(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOfWeek = day.millisecondsSinceEpoch;
    final endOfWeek = beginOfWeek + 7 * 24 * 60 * 60 * 1000;
    List weeklyHomework = [];
    for (var t = beginOfWeek; t < endOfWeek; t = t + 24 * 60 * 60 * 1000) {
      weeklyHomework.add({
        "day": convertTimestampToDayOfWeek(t),
        "homework": getDailyHomework(t)
      });
    }
    return weeklyHomework;
  }
  List getTwoMonthHomework(int timestamp) {
    DateTime now = DateTime.now();
    final beginOfWeek = now.add(Duration(days: 7));
    final endOfWeek = beginOfWeek.add(Duration(days: 62));
    List twoMonthHomework = [];
    for (var t = beginOfWeek; t.isBefore(endOfWeek);  t = t.add(const Duration(days: 1))) {
      twoMonthHomework.add({
        "homework": getDailyHomework(timestamp)
      });
    }
    return twoMonthHomework;
  }
}