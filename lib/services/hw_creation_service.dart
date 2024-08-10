import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'auth_services.dart';

class HwCreationService {
  Future<List<DropdownMenuItem<String>>> fetchClasses() async {
    try {
      // Get the current user's school reference
      String? currentUserId = AuthService.getCurrentUserId();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .doc('/users/$currentUserId/account/permission')
          .get();
      DocumentReference schoolRef = userDoc.get('school');

      // Fetch classes for the school
      QuerySnapshot classSnapshot = await FirebaseFirestore.instance
          .collection('${schoolRef.path}/classes')
          .get();

      // Populate dropdown items for classes
      List<DropdownMenuItem<String>> classItems = classSnapshot.docs
          .map((doc) => DropdownMenuItem<String>(
        value: doc.reference.path,
        child: Text(doc['name']),
      ))
          .toList();

      return classItems;
    } catch (e) {
      // Handle errors
      print('Error fetching classes: $e');
      return [];
    }
  }

  Future<List<DropdownMenuItem<String>>> fetchSubjects() async {
    try {
      // Fetch subjects
      QuerySnapshot subjectSnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .get();

      // Populate dropdown items for subjects
      List<DropdownMenuItem<String>> subjectItems = subjectSnapshot.docs
          .map((doc) => DropdownMenuItem<String>(
        value: doc.reference.path,
        child: Text(doc['name']),
      ))
          .toList();

      return subjectItems;
    } catch (e) {
      // Handle errors
      print('Error fetching subjects: $e');
      return [];
    }
  }

  Future<String> fetchTeacherName() async {
    try {
      // Get the current user's ID
      String? currentUserId = AuthService.getCurrentUserId();

      // Fetch user info
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .doc('/users/$currentUserId')
          .get();

      // Return teacher name
      return userInfo.get('name') as String;
    } catch (e) {
      // Handle errors
      print('Error fetching teacher name: $e');
      return '';
    }
  }
}
