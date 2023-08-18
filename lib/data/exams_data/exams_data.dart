class ExamsData {
  final _exams = [
    {
      "Date": 1670595000000,
      "Name": "Mathematics",
      "Desc": "Don't forget to refresh all the topics that we have covered this semester",
      "Room": "IT Room"
    },
    {
      "Date": 1671259400000,
      "Name": "History",
      "Desc": "Make sure to review the key historical events and figures for this exam",
      "Room": "History Hall"
    },
    {
      "Date": 1671923800000,
      "Name": "Science",
      "Desc": "Study all the scientific theories and concepts discussed in class",
      "Room": "Science Lab"
    },
    {
      "Date": 1672588200000,
      "Name": "Literature",
      "Desc": "Prepare for the literature exam by analyzing the assigned readings and literary devices",
      "Room": "Library"
    },
    {
      "Date": 1673252600000,
      "Name": "Foreign Language",
      "Desc": "Practice your speaking, listening, and writing skills for the language exam",
      "Room": "Language Lab"
    }
  ];

  List getExams() {
    return _exams;
  }
}
