import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/utils/accounting.dart';

class FirestoreData {

  Future<DocumentSnapshot> getDoc(DocumentReference doc) async {
    DocumentSnapshot snapshot = await doc.get();

    // Log the read operation (1 document)
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 1);

    return snapshot;
  }

  Future<List<DocumentSnapshot>> getExams(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('exams')
        .where('uid', isEqualTo: uid)
        .get();

    // Log the read operation
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, grades.docs.length);

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getSubstitutions(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot substitutions = await firestore
        .collection('substitutions')
        .where('uid', isEqualTo: uid)
        .get();

    // Log the read operation
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, substitutions.docs.length);

    return substitutions.docs;
  }

  Future<List<DocumentSnapshot>> getEvents(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot events = await firestore
        .collection('events')
        .where('uid', isEqualTo: uid)
        .get();

    // Log the read operation
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, events.docs.length);

    return events.docs;
  }

  Future<List<DocumentSnapshot>> getGrades(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('grades')
        .where('uid', isEqualTo: uid)
        .get();

    // Log the read operation
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, grades.docs.length);

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getLessons(String classPath, String day, Timestamp timestamp) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference classRef = firestore.doc(classPath);

    QuerySnapshot lessons = await firestore
        .collection('lessons')
        .where('class', isEqualTo: classRef)
        .where('startFrom', isLessThan: timestamp)
        .where('day', isEqualTo: day)
        .get();

    Map<String, DocumentSnapshot> uniqueClasses = {};

    for (DocumentSnapshot doc in lessons.docs) {
      String lessonValue = doc['lesson'].path;
      Timestamp docTimestamp = doc['startFrom'];

      if (uniqueClasses.containsKey(lessonValue)) {
        if (docTimestamp.compareTo(uniqueClasses[lessonValue]!['startFrom']) > 0) {
          uniqueClasses[lessonValue] = doc;
        }
      } else {
        uniqueClasses[lessonValue] = doc;
      }
    }

    List<DocumentSnapshot> sortedDocuments = uniqueClasses.values.toList();
    sortedDocuments.sort((a, b) => a['lesson'].path.compareTo(b['lesson'].path));

    // Log the read operation
    Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, lessons.docs.length);
    return sortedDocuments;
  }

  Future<List<DocumentSnapshot>> getTeacherLessons(String teacherId, String day, Timestamp timestamp) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference teacherDocRef = firestore.collection('users').doc(teacherId);
    DocumentSnapshot teacherDocSnapshot = await getDoc(teacherDocRef);
    DocumentReference teacherRef = teacherDocSnapshot.reference;

    QuerySnapshot lessons = await firestore
        .collection('lessons')
        .where('teacher', isEqualTo: teacherRef)
        .where('startFrom', isLessThan: timestamp)
        .where('day', isEqualTo: day)
        .get();

    Map<String, DocumentSnapshot> uniqueLessons = {};

    for (DocumentSnapshot doc in lessons.docs) {
      String lessonValue = doc['lesson'].path;
      Timestamp docTimestamp = doc['startFrom'];

      if (uniqueLessons.containsKey(lessonValue)) {
        if (docTimestamp.compareTo(uniqueLessons[lessonValue]!['startFrom']) > 0) {
          uniqueLessons[lessonValue] = doc;
        }
      } else {
        uniqueLessons[lessonValue] = doc;
      }
    }

    List<DocumentSnapshot> sortedDocuments = uniqueLessons.values.toList();
    sortedDocuments.sort((a, b) => a['lesson'].path.compareTo(b['lesson'].path));

    // Log the read operation
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, lessons.docs.length);

    return sortedDocuments;
  }

  Future<List<DocumentSnapshot>> getAttendanceLessons(String classPath, Timestamp timestamp) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference classRef = firestore.doc(classPath);

    QuerySnapshot lessons = await firestore
        .collection('lessons')
        .where('class', isEqualTo: classRef)
        .where('startFrom', isLessThan: timestamp)
        .get();

    Map<String, DocumentSnapshot> uniqueClasses = {};

    for (DocumentSnapshot doc in lessons.docs) {
      String lessonValue = doc['lesson'].path;
      Timestamp docTimestamp = doc['startFrom'];

      if (uniqueClasses.containsKey(lessonValue)) {
        if (docTimestamp.compareTo(uniqueClasses[lessonValue]!['startFrom']) > 0) {
          uniqueClasses[lessonValue] = doc;
        }
      } else {
        uniqueClasses[lessonValue] = doc;
      }
    }

    List<DocumentSnapshot> sortedDocuments = uniqueClasses.values.toList();
    sortedDocuments.sort((a, b) => a['lesson'].path.compareTo(b['lesson'].path));

    // Log the read operation
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, lessons.docs.length);

    return sortedDocuments;
  }

  Future<List<DocumentSnapshot>> getHomework(String classPath) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference classRef = firestore.doc(classPath);

    QuerySnapshot homework = await firestore
        .collection('homework')
        .where('class', isEqualTo: classRef)
        .get();

    // Log the read operation
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, homework.docs.length);

    return homework.docs;
  }

  Future<List<DocumentSnapshot>> getAttendance(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot attendance = await firestore
        .collection('attendance')
        .where('student', isEqualTo: uid)
        .get();

    // Log the read operation
    await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, attendance.docs.length);

    return attendance.docs;
  }
}
