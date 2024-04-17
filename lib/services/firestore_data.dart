import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class FirestoreData {
  final _uid = "Tb3HelcRbnQZcxHok9l4YI5pwwI3";

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

  Future<List<DocumentSnapshot>> getWeek() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot week = await firestore.collection('week').get();

    return week.docs;
  }

  static Future<List<DocumentSnapshot>> getLessons(String cls, String day) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot lessons = await firestore
        .collection('lessons')
        .where('class', isEqualTo: cls)
        .where('day', isEqualTo: day)
        .get();
    return lessons.docs;
  }

  Future<DocumentSnapshot> getDoc(DocumentReference doc) async {
    return await doc.get();
  }
}


