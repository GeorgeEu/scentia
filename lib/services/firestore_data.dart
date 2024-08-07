import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreData {

  Future<DocumentSnapshot> getDoc(DocumentReference doc) async {
    return await doc.get();
  }

  Future<List<DocumentSnapshot>> getExams(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('exams') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getSubstitutions(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('substitutions') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getEvents(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('events') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getGrades(DocumentReference uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot grades = await firestore
        .collection('grades') // Replace with your collection name
        .where('uid', isEqualTo: uid) // Assuming 'uid' is the field you're querying
        .get();

    return grades.docs;
  }

  Future<List<DocumentSnapshot>> getLessons(String classPath, String day, Timestamp timestamp) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the class document reference using the full class path
    DocumentReference classRef = firestore.doc(classPath);

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

  Future<List<DocumentSnapshot>> getTeacherLessons(String teacherId, String day, Timestamp timestamp) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the teacher document reference using the getDoc method
    DocumentReference teacherDocRef = firestore.collection('users').doc(teacherId);
    DocumentSnapshot teacherDocSnapshot = await getDoc(teacherDocRef);
    DocumentReference teacherRef = teacherDocSnapshot.reference;

    // Query all documents for the specified day and teacher reference
    QuerySnapshot lessons = await firestore
        .collection('lessons')
        .where('teacher', isEqualTo: teacherRef)
        .where('startFrom', isLessThan: timestamp)
        .where('day', isEqualTo: day)  // Ensure day is queried as string
        .get();

    // Process the documents to keep only one document per class with the latest timestamp
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

    // Return the processed list of documents
    List<DocumentSnapshot> sortedDocuments = uniqueLessons.values.toList();
    sortedDocuments.sort((a, b) => a['lesson'].path.compareTo(b['lesson'].path));

    return sortedDocuments;
  }



  Future<List<DocumentSnapshot>> getAttendanceLessons(String classPath, Timestamp timestamp) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get the class document reference
    DocumentReference classRef = firestore.doc(classPath); // Pay attention here
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






  Future<List<DocumentSnapshot>> getHomework(String classPath) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference classRef = firestore.doc(classPath);

    QuerySnapshot grades = await firestore
        .collection('homework') // Replace with your collection name
        .where('class', isEqualTo: classRef) // Assuming 'uid' is the field you're querying
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


