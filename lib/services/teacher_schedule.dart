import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/models/daily_schedule.dart';

import '../models/daily_teacher_schedule.dart';
import 'auth_services.dart';// Assuming you have an AuthService to get the current user's ID

class TeacherSchedule {
  late final Future<void> _initFuture;
  final Timestamp timestamp;
  late String dayName;
  final FirestoreData firestoreData = FirestoreData();

  final Set<String> weekday = const {
    "SUN",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT"
  };

  TeacherSchedule({required this.timestamp}) {
    _initFuture = _fetchCurrentUserClass();
  }

  Future<void> _fetchCurrentUserClass() async {
    String? userId = AuthService.getCurrentUserId(); // Get current user's ID
    if (userId == null) {
      throw Exception("User not logged in");
    }
  }

  Future<TeacherLesson> _buildLesson(DocumentSnapshot lessonDoc) async {
    DocumentReference teacherRef = lessonDoc['teacher'];
    DocumentReference subjectRef = lessonDoc['subject'];
    DocumentReference lessonRef = lessonDoc['lesson'];

    // Fetch related documents in parallel
    List<Future<DocumentSnapshot>> futures = [
      firestoreData.getDoc(teacherRef),
      firestoreData.getDoc(subjectRef),
      firestoreData.getDoc(lessonRef)
    ];

    List<DocumentSnapshot> results = await Future.wait(futures);

    DocumentSnapshot teacherDoc = results[0];
    DocumentSnapshot subjectDoc = results[1];
    DocumentSnapshot lessonSlotDoc = results[2];

    String start = lessonSlotDoc['start'];
    String end = lessonSlotDoc['end'];
    String subjectName = subjectDoc['name'];
    String teacherName = teacherDoc['name'];

    return TeacherLesson.fromFirestore(
      lessonDoc,
      start,
      end,
      subjectName,
      teacherName,
    );
  }

  Future<DailyTeacherSchedule> getDailyTeacherSchedule(String day) async {
    await _initFuture; // Ensure classId is initialized
    String? userId = AuthService.getCurrentUserId();
    // Fetch the raw schedule
    var rawSchedule = await firestoreData.getTeacherLessons(userId!, day, timestamp);

    List<Future<TeacherLesson>> lessonFutures = rawSchedule.map((lessonDoc) {
      return _buildLesson(lessonDoc);
    }).toList();

    List<TeacherLesson> lessonList = await Future.wait(lessonFutures);

    return DailyTeacherSchedule(schedule: lessonList, day: day, timestamp: timestamp);
  }

  Future<List<DailyTeacherSchedule>> getWeeklyTeacherSchedule() async {
    await _initFuture; // Ensure classId is initialized

    final List<Future<DailyTeacherSchedule>> dailyScheduleFutures = [];

    for (String day in weekday) {
      dailyScheduleFutures.add(getDailyTeacherSchedule(day));
    }

    return await Future.wait(dailyScheduleFutures);
  }
}