import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/models/daily_schedule.dart';

import 'auth_services.dart';// Assuming you have an AuthService to get the current user's ID

class ScheduleService {
  late final Future<void> _initFuture;
  late String classId;
  final Timestamp timestamp;
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

  ScheduleService({required this.timestamp}) {
    _initFuture = _fetchCurrentUserClass();
  }

  Future<void> _fetchCurrentUserClass() async {
    String? userId = AuthService.getCurrentUserId(); // Get current user's ID
    if (userId == null) {
      throw Exception("User not logged in");
    }

    DocumentSnapshot userDoc = await firestoreData.getDoc(
        FirebaseFirestore.instance.collection('users').doc(userId));
    classId = userDoc['class'].id; // Assuming 'classRef' is the field in the user document
  }

  Future<Lesson> _buildLesson(DocumentSnapshot lessonDoc) async {
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

    return Lesson.fromFirestore(
      lessonDoc,
      start,
      end,
      subjectName,
      teacherName,
    );
  }

  Future<DailySchedule> getDailySchedule(String day) async {
    await _initFuture; // Ensure classId is initialized

    final List<Lesson> lessons = [];

    // Fetch the raw schedule
    var rawSchedule = await firestoreData.getLessons(classId, day, timestamp);

    List<Future<Lesson>> lessonFutures = rawSchedule.map((lessonDoc) {
      return _buildLesson(lessonDoc);
    }).toList();

    List<Lesson> lessonList = await Future.wait(lessonFutures);

    return DailySchedule(schedule: lessonList, day: day, timestamp: timestamp);
  }

  Future<List<DailySchedule>> getWeeklySchedule() async {
    await _initFuture; // Ensure classId is initialized

    final List<Future<DailySchedule>> dailyScheduleFutures = [];

    for (String day in weekday) {
      dailyScheduleFutures.add(getDailySchedule(day));
    }

    return await Future.wait(dailyScheduleFutures);
  }
}
