import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreData {

  Future<DocumentSnapshot> getDoc(DocumentReference doc) async {
    return await doc.get();
  }

  Future<List<DocumentSnapshot>> getExams(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('exams') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getSubstitutions(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('substitutions') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getEvents(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('events') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getGrades(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('grades') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getSubjects() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot subjects = await firestore
        .collection('subjects') // Replace with your collection name
        .get();

    return subjects.docs;
  }

  Future<List<DocumentSnapshot>> getLessons(String classId, String day, Timestamp timestamp) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the class document reference
    DocumentReference classRef = firestore.collection('classes').doc(classId);
    // Query all documents for the specified day and class reference
    QuerySnapshot lessons = await firestore
        .collection('lessons')
        .where('class', isEqualTo: classRef)
        .where('startFrom', isLessThan: timestamp)
        .where('day', isEqualTo: day)  // Ensure day is queried as string
        .get();

    // Process the documents to keep only one document per class with the latest timestamp
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
    // Return the processed list of documents
    List<DocumentSnapshot> sortedDocuments = uniqueClasses.values.toList();
    sortedDocuments.sort((a, b) => a['lesson'].path.compareTo(b['lesson'].path));

    return sortedDocuments;
  }

  Future<List<DocumentSnapshot>> getAttendanceLessons(String classId, Timestamp timestamp) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the class document reference
    DocumentReference classRef = firestore.collection('classes').doc(classId);
    // Query all documents for the specified day and class reference
    QuerySnapshot lessons = await firestore
        .collection('lessons')
        .where('class', isEqualTo: classRef)
        .where('startFrom', isLessThan: timestamp)
        .get();

    // Process the documents to keep only one document per class with the latest timestamp
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
    // Return the processed list of documents
    List<DocumentSnapshot> sortedDocuments = uniqueClasses.values.toList();
    sortedDocuments.sort((a, b) => a['lesson'].path.compareTo(b['lesson'].path));

    return sortedDocuments;
  }






  Future<List<DocumentSnapshot>> getHomework(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('homework') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getAttendance(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot attendance = await firestore
        .collection('attendance') // Replace with your collection name
        .where('student', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return attendance.docs;
  }


}


