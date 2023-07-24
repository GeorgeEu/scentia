class HomeworkData {
  final _homework = [
    {
      "Date": 1693830993000,
      "Name": "Chemistry",
      "Task": "Alkanes (15-20)"
    },
    {
      "Date": 1693830993000,
      "Name": "Biology",
      "Task": "Natural Selection"
    },
    {
      "Date": 1693830993000,
      "Name": "Geography",
      "Task": "Learn stuff u know..."
    },
    {
      "Date": 1693917393000,
      "Name": "IELTS",
      "Task": "Part number 7"
    },
    {
      "Date": 1693917393000,
      "Name": "SAT",
      "Task": "Check Khan Academy"
    },
    {
      "Date": 1693917393000,
      "Name": "Biology",
      "Task": "Presentation"
    },
    {
      "Date": 1693917393000,
      "Name": "Geography",
      "Task": "bla-bla-bla"
    },
    {
      "Date": 1694003793000,
      "Name": "IELTS",
      "Task": "Modal Verbs"
    },
    {
      "Date": 1694003793000,
      "Name": "Math",
      "Task": "Make a project about math"
    },
    {
      "Date": 1694090193000,
      "Name": "SAT",
      "Task": "Lorem ipsum dolor sit"
    },
    {
      "Date": 1694090193000,
      "Name": "American History",
      "Task": "Slavery"
    },
    {
      "Date": 1694090193000,
      "Name": "Chemistry",
      "Task": "Revision of all alkanes"
    },
    {
      "Date": 1694176593000,
      "Name": "Math",
      "Task": "Page (110 - 120)"
    },
    {
      "Date": 1694176593000,
      "Name": "SAT",
      "Task": "Finish ex. homework"
    },
    {
      "Date": 1694176593000,
      "Name": "American History",
      "Task": "Industrial Revolution"
    },
    {
      "Date": 1694176593000,
      "Name": "Chemistry",
      "Task": "Revision"
    },
  ];

  List getHomework() {
    //  we get homeworks from server here
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
    final beginOfDay = day.millisecondsSinceEpoch;
    final endOfDay = beginOfDay + 24 * 60 * 60 * 1000 - 1;
    final endOfWeek = endOfDay + 7 * 24 * 60 * 60 * 1000;
    List rawHomework = getHomework();
    List weeklyHomework = [];
    for (var i = 0; i < rawHomework.length; i++) {
      if (rawHomework[i]['Date'] < beginOfDay) continue;
      if (rawHomework[i]['Date'] > endOfWeek) continue;
      weeklyHomework.add(rawHomework[i]);
    }
    return weeklyHomework;
  }
}