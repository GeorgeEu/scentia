import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/services/auth_services.dart';
import 'package:scientia/models/subject_occurrence.dart';
import 'package:scientia/services/user_status_service.dart';

class AttendanceCalc {
  var data = FirestoreData();
  final UserStatusService userService = UserStatusService();

  Future<DocumentSnapshot> _fetchCurrentUserDoc() async {
    String? userId = AuthService.getCurrentUserId(); // Get current user's ID
    if (userId == null) {
      throw Exception("User not logged in");
    }

    DocumentSnapshot userDoc = await data.getDoc(FirebaseFirestore.instance.collection('users').doc(userId));
    return userDoc;
  }

  Future<int> countDaysPastFromSeptember() async {
    DateTime now = DateTime.now();
    DateTime nearestSeptember;
    if (now.month >= 9) {
      nearestSeptember = DateTime(now.year, 9, 1);
    } else {
      nearestSeptember = DateTime(now.year - 1, 9, 1);
    }
    int daysPastFromSeptember = now.difference(nearestSeptember).inDays;
    return daysPastFromSeptember;
  }

  Future<List<SubjectOccurrence>> getLessonOccurrences() async {
    String? userStatus = await userService.getUserStatus();
    if (userStatus != 'student') {
      return []; // Return an empty list or handle as needed
    }

    DocumentSnapshot userDoc = await _fetchCurrentUserDoc();
    var classField = userDoc.get('class'); // Use get to access the field
    if (classField == null) {
      return []; // Return an empty list if the class field is null
    } else if (classField is DocumentReference) {
      // Use the full path of the class document
      String classId = classField.path;

      // Set the timestamp for the query
      Timestamp timestamp = Timestamp.now(); // Replace with actual timestamp if needed

      // Get sorted lessons from query
      List<DocumentSnapshot> sortedDocuments = await data.getAttendanceLessons(classId, timestamp);

      // Calculate days past from nearest September
      int daysPastFromSeptember = await countDaysPastFromSeptember();
      double weeksPastFromSeptember = daysPastFromSeptember / 7;

      // Count the occurrences of each lesson
      Map<String, int> lessonOccurrences = {};

      List<Future<void>> futures = sortedDocuments.map((doc) async {
        DocumentReference subjectRef = doc['subject'];
        DocumentSnapshot subjectDoc = await data.getDoc(subjectRef); // Use the getDoc function from the data file
        String subjectName = subjectDoc['name'];

        if (lessonOccurrences.containsKey(subjectName)) {
          lessonOccurrences[subjectName] = lessonOccurrences[subjectName]! + 1;
        } else {
          lessonOccurrences[subjectName] = 1;
        }
      }).toList();

      await Future.wait(futures);

      // Calculate occurrences per week
      List<SubjectOccurrence> subjectOccurrencesList = [];
      lessonOccurrences.forEach((subjectName, occurrences) {
        int occurrencesPerWeek = (occurrences * weeksPastFromSeptember).floor();
        subjectOccurrencesList.add(SubjectOccurrence(subject: subjectName, occurrences: occurrencesPerWeek));
      });

      return subjectOccurrencesList;
    } else {
      throw Exception("Unexpected value type for class field");
    }
  }

  Future<List<SubjectOccurrence>> getFilteredAttendanceOccurrences() async {
    DocumentSnapshot userDoc = await _fetchCurrentUserDoc();
    DocumentReference userRef = userDoc.reference;
    List<DocumentSnapshot> attendanceDocs = await data.getAttendance(userRef);

    List<DocumentSnapshot> filteredDocs = attendanceDocs.where((doc) {
      return doc['status'] == 'Absence';
    }).toList();

    // Map to store occurrences
    Map<String, int> attendanceOccurrences = {};

    List<Future<void>> futures = filteredDocs.map((doc) async {
      DocumentReference subjectRef = doc['subject'];
      DocumentSnapshot subjectDoc = await data.getDoc(subjectRef);
      DocumentReference nestedSubjectRef = subjectDoc['subject'];
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      if (attendanceOccurrences.containsKey(subjectName)) {
        attendanceOccurrences[subjectName] = attendanceOccurrences[subjectName]! + 1;
      } else {
        attendanceOccurrences[subjectName] = 1;
      }
    }).toList();

    await Future.wait(futures);

    // Create a list of SubjectOccurrence
    List<SubjectOccurrence> subjectAbsenceOccurrencesList = [];
    attendanceOccurrences.forEach((subjectName, occurrences) {
      subjectAbsenceOccurrencesList.add(SubjectOccurrence(subject: subjectName, occurrences: occurrences));
    });

    return subjectAbsenceOccurrencesList;
  }

  Future<Map<String, double>> calculateAbsencePercentagePerSubject() async {
    // Fetch total lessons and absences in parallel
    var results = await Future.wait([
      getLessonOccurrences(),
      getFilteredAttendanceOccurrences(),
    ]);

    List<SubjectOccurrence> totalLessons = results[0];
    List<SubjectOccurrence> absenceOccurrences = results[1];

    // Create a map for total lesson occurrences
    Map<String, int> totalLessonsMap = {};
    totalLessons.forEach((occurrence) {
      totalLessonsMap[occurrence.subject] = occurrence.occurrences;
    });

    // Create a map for absence occurrences
    Map<String, int> absenceOccurrencesMap = {};
    absenceOccurrences.forEach((occurrence) {
      absenceOccurrencesMap[occurrence.subject] = occurrence.occurrences;
    });

    // Calculate the percentage of missed lessons for each subject
    Map<String, double> absencePercentageMap = {};
    totalLessonsMap.forEach((subject, totalOccurrences) {
      int missedOccurrences = absenceOccurrencesMap[subject] ?? 0;
      double percentage = (missedOccurrences / totalOccurrences) * 100;
      absencePercentageMap[subject] = percentage;
    });

    return absencePercentageMap;
  }
}
