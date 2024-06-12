import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreData {

  CollectionReference getExams() {
    final CollectionReference _exams =
        FirebaseFirestore.instance.collection('exams');
    return _exams;
  }

  CollectionReference getSubstitutions() {
    final CollectionReference _substitutions =
        FirebaseFirestore.instance.collection('substitutions');
    return _substitutions;
  }

  CollectionReference getEvents() {
    final CollectionReference _events =
        FirebaseFirestore.instance.collection('events');
    return _events;
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

  Future<DocumentSnapshot> getDailyRings(String day) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot rings = await firestore.collection('week')
        .where('name', isEqualTo: day)
        .get();
    return rings.docs[0];
  }

  Future<List<DocumentSnapshot>> getLessons(String cls, String day) async {
    final DateTime now = DateTime.now();
    Timestamp nowTimestamp = Timestamp.fromDate(now);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Query all documents for the specified day and class
    QuerySnapshot lessons = await firestore
        .collection('lessons')
        .where('class', isEqualTo: cls)
        .where('startFrom', isLessThan: nowTimestamp)
        .where('day', isEqualTo: day)
        .get();

    // Process the documents to keep only one document per class with the latest timestamp
    Map<int, DocumentSnapshot> uniqueClasses = {};

    for (DocumentSnapshot doc in lessons.docs) {
      int lessonValue = doc['lesson'];
      Timestamp timestamp = doc['startFrom'];

      if (uniqueClasses.containsKey(lessonValue)) {
        if (timestamp.compareTo(uniqueClasses[lessonValue]!['startFrom']) > 0) {
          uniqueClasses[lessonValue] = doc;
        }
      } else {
        uniqueClasses[lessonValue] = doc;
      }
    }

    // Return the processed list of documents
    List<DocumentSnapshot> sortedDocuments = uniqueClasses.values.toList();
    sortedDocuments.sort((a, b) => a['lesson'].compareTo(b['lesson']));

    // Return the sorted list of documents
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



  Future<DocumentSnapshot> getDoc(DocumentReference doc) async {
    return await doc.get();
  }
}


