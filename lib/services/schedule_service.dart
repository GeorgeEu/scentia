import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/services/firestore_data.dart';
import 'dart:developer';
import 'dart:convert';

class Subject {
  final String start;
  final String end;
  final String name;
  final String teacher;

  const Subject(
      {required this.start,
      required this.end,
      required this.name,
      required this.teacher});
}

class DailySchedule {
  final String day;
  final List<Subject> schedule;

  const DailySchedule({required this.schedule, required this.day});
}

class ScheduleService {
  final String cls;
  late List<Subject> subjects;
  final Set<String> weekday = const {
    "SUN",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT"
  };

  ScheduleService({required this.cls});

  Future<DailySchedule> getDailySchedule() async {
    final List<Subject> lessons = [];
    var data = FirestoreData();
    var rings = await data.getDailyRings('MON');
    var rawSchedule = await data.getLessons('12a', 'MON');
    var dailyRings = rings.data();

    for (DocumentSnapshot lesson in rawSchedule) {
      var teacher = await data.getDoc(lesson['teacher']);
      int number = lesson['lesson'];
      var subjectName = await data.getDoc(lesson['subject']);

      var subject = Subject(
          start: rings['lessons'][number]['start'], end: rings['lessons'][number]['end'], name: subjectName['name'], teacher: teacher['name']);
      lessons.add(subject);
    }

    print('*****************************************');
    print(lessons[0].name);
    return DailySchedule(schedule: lessons, day: 'MON');
  }
}
