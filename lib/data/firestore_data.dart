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
}
