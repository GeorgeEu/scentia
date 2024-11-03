import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/school_service.dart';

class ClassesSpotsStatusService {
  Future<Map<String, bool>> checkStatus() async {
    // Fetch the current user's school ID
    SchoolService schoolService = SchoolService();
    String? schoolId = await schoolService.getCurrentUserSchoolId();

    bool classesExist = false;
    bool lessonsExist = false;

    // Check if the 'classes' subcollection exists
    QuerySnapshot classesSnapshot = await FirebaseFirestore.instance
        .collection('schools')
        .doc(schoolId)
        .collection('classes')
        .limit(1)
        .get();

    if (classesSnapshot.docs.isNotEmpty) {
      classesExist = true;
    }

    // Check if the 'week' document exists
    DocumentSnapshot weekDocSnapshot = await FirebaseFirestore.instance
        .collection('week')
        .doc(schoolId)
        .get();

    if (weekDocSnapshot.exists) {
      lessonsExist = true;
    }

    // Return the status as a Map
    return {
      'classesExist': classesExist,
      'lessonsExist': lessonsExist,
    };
  }
}
