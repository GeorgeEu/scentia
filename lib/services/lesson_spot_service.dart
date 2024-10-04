import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'school_service.dart';

class LessonSpotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to save the lesson spots to Firebase
  Future<void> saveLessonSpots(
      String selectedClassName,
      Map<String, List<Map<String, TimeOfDay>>> lessonsPerDay,
      ) async {
    try {
      // Step 1: Fetch the current user's school ID using SchoolService
      SchoolService schoolService = SchoolService();
      String? schoolId = await schoolService.getCurrentUserSchoolId();

      if (schoolId == null) {
        print("No school ID found for the current user.");
        return;
      }

      // Step 2: Reference to the school document in the 'week' collection
      DocumentReference schoolDocRef =
      _firestore.collection('week').doc(schoolId);

      // Ensure the school document exists
      await schoolDocRef.set(<String, dynamic>{}, SetOptions(merge: true));

      // Step 3: Reference to the class document
      DocumentReference classDocRef =
      schoolDocRef.collection('classes').doc(selectedClassName);

      // Ensure the class document exists
      await classDocRef.set(<String, dynamic>{}, SetOptions(merge: true));

      // Step 4: Reference to the 'days' collection inside the class document
      CollectionReference daysCollectionRef = classDocRef.collection('days');

      // Iterate over the lessonsPerDay map
      int dayIndex = 1; // Used for day document IDs (1, 2, 3, etc.)
      for (MapEntry<String, List<Map<String, TimeOfDay>>> entry
      in lessonsPerDay.entries) {
        String abbreviatedDay = entry.key; // Key is already a String
        List<Map<String, TimeOfDay>> lessons = entry.value;

        // Save the day document with the day abbreviation
        DocumentReference dayDocRef =
        daysCollectionRef.doc(dayIndex.toString());
        await dayDocRef.set({
          'name': abbreviatedDay, // 'name' is a String key
        });

        // Step 5: Create the 'slots' sub-collection for time slots if there are lessons
        if (lessons.isNotEmpty) {
          CollectionReference slotsCollectionRef = dayDocRef.collection('slots');
          int slotIndex = 1;

          for (Map<String, TimeOfDay> lesson in lessons) {
            TimeOfDay startTime = lesson['startTime']!;
            TimeOfDay endTime = lesson['endTime']!;

            // Convert TimeOfDay to String in "HH:mm" format
            String startTimeString = _formatTimeOfDay(startTime);
            String endTimeString = _formatTimeOfDay(endTime);

            // Save the time slots with String keys
            await slotsCollectionRef.doc(slotIndex.toString()).set({
              'start': startTimeString, // 'start' is a String key
              'end': endTimeString,     // 'end' is a String key
            });
            slotIndex++; // Increment slot index
          }
        }

        dayIndex++; // Increment day index for the next day
      }

      print("Lesson spots successfully saved.");
    } catch (e) {
      print("Error saving lesson spots: $e");
      throw e; // Re-throw the exception to be caught in the UI code
    }
  }

  // Helper method to format TimeOfDay to "HH:mm" string
  String _formatTimeOfDay(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String formattedHour = hour.toString().padLeft(2, '0');
    final String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute';
  }
}
