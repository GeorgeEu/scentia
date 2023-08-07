import 'package:intl/intl.dart';

class GradesData {
  final _grades = [
    {
      "Date": 1693830993000,
      "Lesson": "Chemistry",
      "Grade": "11"
    },
    {
      "Date": 1693830993000,
      "Lesson": "Biology",
      "Grade": "10"
    },
    {
      "Date": 1693830993000,
      "Lesson": "Geography",
      "Grade": "10"
    },
    {
      "Date": 1693917393000,
      "Lesson": "IELTS",
      "Grade": "11"
    },
    {
      "Date": 1693917393000,
      "Lesson": "SAT",
      "Grade": "10"
    },
    {
      "Date": 1693917393000,
      "Lesson": "SAT",
      "Grade": "9"
    },
    {
      "Date": 1693917393000,
      "Lesson": "Biology",
      "Grade": "10"
    },
    {
      "Date": 1693917393000,
      "Lesson": "Geography",
      "Grade": "10"
    },
    {
      "Date": 1693917393000,
      "Lesson": "Geography",
      "Grade": "9"
    },
    {
      "Date": 1694003793000,
      "Lesson": "IELTS",
      "Grade": "10"
    },
    {
      "Date": 1694090193000,
      "Lesson": "SAT",
      "Grade": "10"
    },
    {
      "Date": 1694003793000,
      "Lesson": "Math",
      "Grade": "10"
    },
    {
      "Date": 1694090193000,
      "Lesson": "American History",
      "Grade": "10"
    },
    {
      "Date": 1694176593000,
      "Lesson": "Math",
      "Grade": "10"
    },
    {
      "Date": 1694090193000,
      "Lesson": "Chemistry",
      "Grade": "10"
    },
    {
      "Date": 1694176593000,
      "Lesson": "SAT",
      "Grade": "10"
    },
    {
      "Date": 1694176593000,
      "Lesson": "American History",
      "Grade": "10"
    },
    {
      "Date": 1694176593000,
      "Lesson": "Chemistry",
      "Grade": "10"
    },
  ];

  String convertTimestampToDayOfWeek(int timestamp) {
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String fdatetime = DateFormat('EEEE').format(
        tsdate); // Corrected the format string to 'yyyy'
    return fdatetime;
  }

  List getGrades() {
    return _grades;
  }

  List getDailyGrades(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOftDay = day.millisecondsSinceEpoch;
    final endOfDay = beginOftDay + 24 * 60 * 60 * 1000 - 1;
    List rawGrades = getGrades();
    List grades = [];
    for (var i = 0; i < rawGrades.length; i++) {
      if (rawGrades[i]['Date'] < beginOftDay) continue;
      if (rawGrades[i]['Date'] > endOfDay) continue;
      grades.add(rawGrades[i]);
    }
    return grades;
  }

  // FROM ABOVE We get daily homework FROM BELOW We get weekly homework
  List getWeeklyGrades(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime day = DateTime(date.year, date.month, date.day);
    final beginOfWeek = day.millisecondsSinceEpoch;
    final endOfWeek = beginOfWeek + 7 * 24 * 60 * 60 * 1000;
    List weeklyGrades = [];
    for (var t = beginOfWeek; t < endOfWeek; t = t + 24 * 60 * 60 * 1000) {
      weeklyGrades.add({
        "day": convertTimestampToDayOfWeek(t),
        "grades": getDailyGrades(t)
      });
    }
    return weeklyGrades;
  }

  List getSubjectGrades() {
    final grades = getGrades();
    var subjects = Set<String>();
    grades.forEach((grade) => subjects.add(grade['Lesson']));
    List allSubjectGrades = [];
    subjects.forEach((subject) {
      List subjectGrades = [];
      List marks = [];
      marks = grades.where((grade) => grade['Lesson'] == subject).toList();
      subjectGrades.add({
        "Lesson": subject,
        "Grades": marks
      });
      allSubjectGrades.add(subjectGrades);
    });
    return allSubjectGrades;
  }
}