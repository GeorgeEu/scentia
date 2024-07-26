import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final DocumentReference classRef;
  final String day;
  final DocumentReference lessonRef;
  final String start;
  final String end;
  final DocumentReference subjectRef;
  final DocumentReference teacherRef;
  final String subjectName;
  final String teacherName;

  Lesson({
    required this.classRef,
    required this.day,
    required this.lessonRef,
    required this.start,
    required this.end,
    required this.subjectRef,
    required this.teacherRef,
    required this.subjectName,
    required this.teacherName,
  });

  factory Lesson.fromFirestore(DocumentSnapshot doc, String start, String end, String subjectName, String teacherName) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Lesson(
      classRef: data['class'],
      day: data['day'],
      lessonRef: data['lesson'],
      start: start,
      end: end,
      subjectRef: data['subject'],
      teacherRef: data['teacher'],
      subjectName: subjectName,
      teacherName: teacherName,
    );
  }
}

class DailySchedule {
  final String day;
  final Timestamp timestamp;
  final List<Lesson> schedule;

  DailySchedule({
    required this.schedule,
    required this.day,
    required this.timestamp,
  });
}
