import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_services.dart';

class InstitutionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to check and create a document for the user in the 'scentia' collection
  Future<void> checkAndCreateUserDocument(String? userId, String displayName) async {
    if (userId == null) {
      throw Exception("User ID is null.");
    }

    DocumentReference userDocRef = _firestore.collection('scentia').doc(userId);
    DocumentSnapshot userDoc = await userDocRef.get();

    // If the user document does not exist, create it with initial fields
    if (!userDoc.exists) {
      await userDocRef.set({
        'balance': 0, // Initial balance set to 0
        'name': displayName, // Set the user's display name
      });
    }
  }

  // Function to check and create a school document for the user in the 'schools' collection
  Future<void> checkAndCreateSchoolDocument(String? userId, String schoolName) async {
    if (userId == null) {
      throw Exception("User ID is null.");
    }

    // Create a reference path like 'scentia/userId'
    DocumentReference userRef = _firestore.collection('scentia').doc(userId);
    QuerySnapshot schoolQuery = await _firestore
        .collection('schools')
        .where('owner', isEqualTo: userRef) // Check if there's already a school with this owner
        .get();

    // If no document found, create a new school document
    if (schoolQuery.docs.isEmpty) {
      DocumentReference newSchoolDoc = _firestore.collection('schools').doc(); // Generate a random document ID
      await newSchoolDoc.set({
        'owner': userRef, // Reference to the owner (the user path we created)
        'name': schoolName, // Name of the school
      });

      // Optionally, create an empty sub-collection 'classes' inside the new school document
      CollectionReference classesCollection = newSchoolDoc.collection('classes');
      // Add logic here to initialize the 'classes' sub-collection if needed
    }
  }

  // Combined function to be called when 'Create Institution' is pressed
  Future<void> createInstitution(String schoolName) async {
    try {
      String? userId = AuthService.getCurrentUserId();
      final user = FirebaseAuth.instance.currentUser!;
      final displayName = user.displayName ?? "Unnamed";

      // Step 1: Check and create user document
      await checkAndCreateUserDocument(userId, displayName);

      // Step 2: Check and create school document
      await checkAndCreateSchoolDocument(userId, schoolName);
    } catch (e) {
      print("Error creating institution: $e");
      throw Exception("Failed to create institution.");
    }
  }
}
