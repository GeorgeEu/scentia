import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/accounting.dart';
import 'auth_services.dart';
import 'firestore_data.dart';

class GradeCreationService {
  final FirestoreData firestoreData = FirestoreData();

  // Fetch classes and return them as a list of Class objects
  Future<List<Class>> fetchClasses() async {
    try {
      // Get the current user's school reference
      String? currentUserId = AuthService.getCurrentUserId();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .doc('/users/$currentUserId/account/permission')
          .get();

      // Count the user document read
      await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 1); // 1 document read

      DocumentReference schoolRef = userDoc.get('school');

      // Fetch classes for the school
      QuerySnapshot classSnapshot = await FirebaseFirestore.instance
          .collection('${schoolRef.path}/classes')
          .get();

      // Count the number of documents read for classes
      await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, classSnapshot.docs.length); // Multiple documents read

      // Create a list of Class objects
      List<Class> classList = classSnapshot.docs.map((doc) {
        return Class(
          id: doc.reference.path,
          name: doc['name'],
        );
      }).toList();

      return classList;
    } catch (e) {
      // Handle errors
      print('Error fetching classes: $e');
      return [];
    }
  }


  // Fetch students for a given class and return them as a list of Student objects
  Future<List<Student>> fetchStudentsForClasses(List<Class> classes) async {
    try {
      List<Student> allStudents = [];

      for (var classItem in classes) {
        // Fetch class document
        DocumentSnapshot classDoc = await FirebaseFirestore.instance.doc(classItem.id).get();

        // Count the class document read
        await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 1); // 1 document read for the class

        // Fetch the list of student references from the class document
        List<dynamic> studentRefs = classDoc.get('students') ?? [];

        // Loop through each student reference
        for (var studentRef in studentRefs) {
          DocumentSnapshot studentDoc = await FirestoreData().getDoc(studentRef);

          // Count the student document read
          await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 1); // 1 document read for each student

          allStudents.add(Student(
            id: studentDoc.reference.path,
            name: studentDoc.get('name'),
          ));
        }
      }

      return allStudents;
    } catch (e) {
      print('Error fetching students: $e');
      return [];
    }
  }



  // Fetch subjects (if needed for other menus)
  Future<List<Subject>> fetchSubjects() async {
    try {
      // Fetch subjects
      QuerySnapshot subjectSnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .get();
      await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, subjectSnapshot.docs.length);

      // Create a list of Subject objects
      List<Subject> subjectList = subjectSnapshot.docs.map((doc) {
        return Subject(
          id: doc.reference.path,
          name: doc['name'],
        );
      }).toList();

      return subjectList;
    } catch (e) {
      // Handle errors
      print('Error fetching subjects: $e');
      return [];
    }
  }

  // Fetch the teacher's name
  Future<String> fetchTeacherName() async {
    try {
      // Get the current user's ID
      String? currentUserId = AuthService.getCurrentUserId();

      // Fetch user info
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .doc('/users/$currentUserId')
          .get();

      await Accounting.detectAndStoreOperation(DatabaseOperation.dbRead, 1);
      // Return teacher name
      return userInfo.get('name') as String;
    } catch (e) {
      // Handle errors
      print('Error fetching teacher name: $e');
      return '';
    }
  }
}

class Class {
  final String id;
  final String name;

  Class({required this.id, required this.name});
}

class Student {
  final String id;
  final String name;

  Student({required this.id, required this.name});
}

class Subject {
  final String id;
  final String name;

  Subject({required this.id, required this.name});
}

class Lesson {
  TimeOfDay startTime;
  TimeOfDay endTime;

  Lesson({required this.startTime, required this.endTime});
}

class Day {
  String dayName;
  List<Lesson> lessons;

  Day({required this.dayName, required this.lessons});
}
