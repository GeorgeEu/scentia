import 'package:cloud_firestore/cloud_firestore.dart';

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
  late Timestamp timestamp;
  final List<Subject> schedule;

  DailySchedule({required this.schedule, required this.day, required this.timestamp});
}
