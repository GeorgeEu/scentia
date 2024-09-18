import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'firestore_data.dart';

class HistoryService {
  final FirestoreData data = FirestoreData();

  // Fetch and prepare homework data
  Future<List<Map<String, dynamic>>> getHomeworkHistory(String teacherName) async {
    List<DocumentSnapshot> homeworkDocs = await data.getHistoryHomework(teacherName);
    List<Future<Map<String, dynamic>>> homeworkFutures = homeworkDocs.map((homework) async {
      var homeworkData = homework.data() as Map<String, dynamic>;

      DocumentSnapshot subjectDoc = await data.getDoc(homeworkData['subject']);
      DocumentSnapshot classDoc = await data.getDoc(homeworkData['class']);
      String className = classDoc['name'];
      String subjectName = subjectDoc['name'];

      return {
        'id': homework.id,
        'type': 'homework',
        'task': homeworkData['task'],
        'subject': subjectName,
        'date': homeworkData['endAt'],  // Store the Firestore Timestamp directly
        'class': className,
        'createdAt': homeworkData['createdAt']
      };
    }).toList();

    return await Future.wait(homeworkFutures);
  }

  Future<List<Map<String, dynamic>>> getGradeHistory(String teacherName) async {
    List<DocumentSnapshot> grades = await data.getHistoryGrades(teacherName);

    List<Map<String, dynamic>> gradeDataList = [];
    for (var grade in grades) {
      var gradeData = grade.data() as Map<String, dynamic>;

      DocumentSnapshot subjectDoc = await data.getDoc(gradeData['sid']);
      String subjectName = subjectDoc['name'];
      
      DocumentSnapshot userDoc = await data.getDoc(gradeData['uid']);
      String userName = userDoc['name'];
      gradeDataList.add({
        'id': grade.id,
        'type': 'grade',
        'grade': gradeData['grade'],
        'subject': subjectName,
        'date': gradeData['date'],  // Store the Firestore Timestamp directly
        'createdAt': gradeData['createdAt'],
        'user': userName
      });
    }

    return gradeDataList;
  }

  Future<List<Map<String, dynamic>>> getEventHistory(String teacherName) async {
    List<DocumentSnapshot> events = await data.getHistoryEvents(teacherName);

    List<Future<Map<String, dynamic>>> eventFutures = events.map((event) async {
      var eventData = event.data() as Map<String, dynamic>;
      DocumentSnapshot classDoc = await data.getDoc(eventData['class']);
      String className = classDoc['name'];

      return {
        'id': event.id,
        'type': 'event',
        'desc': eventData['desc'],
        'name': eventData['name'],
        'class': className,
        'imageUrl': eventData['imageUrl'],
        'date': eventData['date'],  // Store the Firestore Timestamp directly
        'createdAt':eventData['createdAt']
      };
    }).toList();

    return await Future.wait(eventFutures);
  }

  Future<List<Map<String, dynamic>>> getCombinedHistory(String teacherName) async {
    // Run all fetches concurrently
    final results = await Future.wait([
      getHomeworkHistory(teacherName),
      getGradeHistory(teacherName),
      getEventHistory(teacherName),
    ]);

    // Combine the results
    List<Map<String, dynamic>> combinedHistory = [
      ...results[0],  // homeworkHistory
      ...results[1],  // gradeHistory
      ...results[2],  // eventHistory
    ];

    // Sort by date using the Firestore Timestamp directly
    combinedHistory.sort((a, b) => (b['createdAt'] as int).compareTo(a['createdAt'] as int));

    return combinedHistory;
  }

}
