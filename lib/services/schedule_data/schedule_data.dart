import 'package:intl/intl.dart';

class ScheduleData {
  final _schedule = [
    {
      "Date": 1678723200000,
      "Schedule": [
        {
          "Name": "American History",
          "Time": "09:00"
        },
        {
          "Name": "Chemistry",
          "Time": "09:55"
        },
        {
          "Name": "Biology",
          "Time": "10:45"
        },
        {
          "Name": "Geography",
          "Time": "11:40"
        },
        {
          "Name": "IELTS",
          "Time": "12:35"
        },
        {
          "Name": "Math",
          "Time": "13:30"
        },
        {
          "Name": "SAT",
          "Time": "14:20"
        }
      ]
    },
    {
      "Date": 1678809600000,
      "Schedule": [
        {
          "Name": "English",
          "Time": "09:00"
        },
        {
          "Name": "Geography",
          "Time": "09:55"
        },
        {
          "Name": "English",
          "Time": "10:45"
        },
        {
          "Name": "German",
          "Time": "11:40"
        },
        {
          "Name": "Georgian",
          "Time": "12:35"
        },
        {
          "Name": "Math",
          "Time": "13:30"
        },
        {
          "Name": "Sport",
          "Time": "14:20"
        }
      ]
    },
    {
      "Date": 1678896000000,
      "Schedule": [
        {
          "Name": "History",
          "Time": "09:00"
        },
        {
          "Name": "Leadership",
          "Time": "09:55"
        },
        {
          "Name": "Georgian",
          "Time": "10:45"
        },
        {
          "Name": "English",
          "Time": "11:40"
        },
        {
          "Name": "Math",
          "Time": "12:35"
        },
        {
          "Name": "Bla-Bla-Bla-Bla-Bla-Bla-Bla",
          "Time": "13:30"
        },
        {
          "Name": "History",
          "Time": "14:20"
        }
      ]
    },
    {
      "Date": 1678982400000,
      "Schedule": [
        {
          "Name": "SAT",
          "Time": "09:00"
        },
        {
          "Name": "English",
          "Time": "09:55"
        },
        {
          "Name": "IELTS",
          "Time": "10:45"
        },
        {
          "Name": "Math",
          "Time": "11:40"
        },
        {
          "Name": "Physics",
          "Time": "12:35"
        },
        {
          "Name": "German",
          "Time": "13:30"
        },
        {
          "Name": "Driving lessons",
          "Time": "14:20"
        }
      ]
    },
    {
      "Date": 1679068800000,
      "Schedule": [
        {
          "Name": "Physics",
          "Time": "09:00"
        },
        {
          "Name": "Biology",
          "Time": "09:55"
        },
        {
          "Name": "Chemistry",
          "Time": "10:45"
        },
        {
          "Name": "English",
          "Time": "11:40"
        },
        {
          "Name": "Math",
          "Time": "12:35"
        },
        {
          "Name": "Georgian",
          "Time": "13:30"
        }
      ]
    },
    {
      "Date": 1679328000000,
      "Schedule": [
        {
          "Name": "Physics",
          "Time": "09:00"
        },
        {
          "Name": "Biology",
          "Time": "09:55"
        },
        {
          "Name": "Chemistry",
          "Time": "10:45"
        },
        {
          "Name": "English",
          "Time": "11:40"
        },
        {
          "Name": "Math",
          "Time": "12:35"
        },
        {
          "Name": "Georgian",
          "Time": "13:30"
        }
      ]
    },
    {
      "Date": 1679414400000,
      "Schedule": [
        {
          "Name": "Physics",
          "Time": "09:00"
        },
        {
          "Name": "11",
          "Time": "09:55"
        },
        {
          "Name": "22",
          "Time": "10:45"
        },
        {
          "Name": "33",
          "Time": "11:40"
        },
        {
          "Name": "Math",
          "Time": "12:35"
        },
        {
          "Name": "Georgian",
          "Time": "13:30"
        }
      ]
    },
    {
      "Date": 1679500800000,
      "Schedule": [
        {
          "Name": "Physics",
          "Time": "09:00"
        },
        {
          "Name": "Biology",
          "Time": "09:55"
        },
        {
          "Name": "Chemistry",
          "Time": "10:45"
        },
        {
          "Name": "English",
          "Time": "11:40"
        },
        {
          "Name": "Math",
          "Time": "12:35"
        },
        {
          "Name": "Georgian",
          "Time": "13:30"
        }
      ]
    },
    {
      "Date": 1679587200000,
      "Schedule": [
        {
          "Name": "Physics",
          "Time": "09:00"
        },
        {
          "Name": "Biology",
          "Time": "09:55"
        },
        {
          "Name": "Chemistry",
          "Time": "10:45"
        },
        {
          "Name": "English",
          "Time": "11:40"
        },
        {
          "Name": "Math",
          "Time": "12:35"
        },
        {
          "Name": "Georgian",
          "Time": "13:30"
        }
      ]
    },
    {
      "Date": 1679673600000,
      "Schedule": [
        {
          "Name": "Physics",
          "Time": "09:00"
        },
        {
          "Name": "Biology",
          "Time": "09:55"
        },
        {
          "Name": "Chemistry",
          "Time": "10:45"
        },
        {
          "Name": "English",
          "Time": "11:40"
        },
        {
          "Name": "Math",
          "Time": "12:35"
        },
        {
          "Name": "Georgian",
          "Time": "13:30"
        }
      ]
    },
  ];


  String convertTimestampToDayOfWeek(int timestamp) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String fdatetime = DateFormat('EEEE').format(tsdate); // Corrected the format string to 'yyyy'
    return fdatetime;
  }

  List getSchedule() {
    return _schedule;
  }


  List getDailySchedule(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOftDay = day.millisecondsSinceEpoch;
    final endOfDay = beginOftDay + 24 * 60 * 60 * 1000 - 1;
    List rawDaySchedule = getSchedule();
    List schedule = [];
    for (var i = 0; i < rawDaySchedule.length; i++) {
      if (rawDaySchedule[i]['Date'] < beginOftDay) continue;
      if (rawDaySchedule[i]['Date'] > endOfDay) continue;
      schedule = rawDaySchedule[i]["Schedule"];
    }
    return schedule;
  }

  List getWeeklySchedule(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOfWeek = day.millisecondsSinceEpoch;
    final endOfWeek = beginOfWeek + 7 * 24 * 60 * 60 * 1000;
    List weeklySchedule = [];
    for (var t = beginOfWeek; t < endOfWeek; t = t + 24 * 60 * 60 * 1000) {
      weeklySchedule.add({
        'day': convertTimestampToDayOfWeek(t),
        "schedule": getDailySchedule(t),
      });
    }
    return weeklySchedule;
  }

  List getSecondWeekSchedule(int timestamp) {
    final secondWeekBegin = timestamp + 7 * 24 * 60 * 60 * 1000 + 1;
    final secondWeekSchedule = getWeeklySchedule(secondWeekBegin);
    /*DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOfWeek = day.millisecondsSinceEpoch  + 7 * 24 * 60 * 60 * 1000 + 1;
    final endOfWeek = beginOfWeek + 14 * 24 * 60 * 60 * 1000;
    List weeklySchedule = [];
    for (var t = beginOfWeek; t < endOfWeek; t = t + 24 * 60 * 60 * 1000) {
      weeklySchedule.add({
        'day': convertTimestampToDayOfWeek(t),
        "schedule": getDailySchedule(t),
      });
    }*/
    return secondWeekSchedule;
  }
}