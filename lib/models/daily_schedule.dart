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
