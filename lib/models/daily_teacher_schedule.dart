import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherLesson {
  final String day;
  final DocumentReference lessonRef;
  final String start;
  final String end;
  final DocumentReference subjectRef;
  final DocumentReference teacherRef;
  final String subjectName;
  final String teacherName;

  TeacherLesson({
    required this.day,
    required this.lessonRef,
    required this.start,
    required this.end,
    required this.subjectRef,
    required this.teacherRef,
    required this.subjectName,
    required this.teacherName,
  });

  factory TeacherLesson.fromFirestore(DocumentSnapshot doc, String start, String end, String subjectName, String teacherName) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TeacherLesson(
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

class DailyTeacherSchedule {
  final String day;
  final Timestamp timestamp;
  final List<TeacherLesson> schedule;

  DailyTeacherSchedule({
    required this.schedule,
    required this.day,
    required this.timestamp,
  });
}