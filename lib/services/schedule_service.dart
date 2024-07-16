import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/models/daily_schedule.dart';

class ScheduleService {
  final String cls;
  final Timestamp timestamp;
  final Set<String> weekday = const {
    "SUN",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT"
  };

  ScheduleService({required this.cls, required this.timestamp});

  Future<DailySchedule> getDailySchedule(String day) async {
    final List<Subject> lessons = [];
    var data = FirestoreData();

    var rings = await data.getDailyRings(day);
    var rawSchedule = await data.getLessons(cls, day, timestamp);

    for (DocumentSnapshot lesson in rawSchedule) {
      var teacher = await data.getDoc(lesson['teacher']);
      int number = lesson['lesson'];
      var subjectName = await data.getDoc(lesson['subject']);

      var subject = Subject(
          start: rings['lessons'][number]['start'],
          end: rings['lessons'][number]['end'],
          name: subjectName['name'],
          teacher: teacher['name']);
      lessons.add(subject);
    }

    return DailySchedule(schedule: lessons, day: day, timestamp: timestamp);
  }

  Future<List<DailySchedule>> getWeeklySchedule() async {
    final List<DailySchedule> weeklySchedule = [];

    for (String day in weekday) {
      final DailySchedule dayData = await getDailySchedule(day);
      weeklySchedule.add(dayData);
    }
    return weeklySchedule;
  }
}
