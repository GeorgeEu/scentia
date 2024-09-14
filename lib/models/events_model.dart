import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class EventsModel {
  final FirestoreData data = FirestoreData();
  late String classId;

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      throw Exception("User not logged in");
    }

    DocumentSnapshot userDoc = await data
        .getDoc(FirebaseFirestore.instance.collection('users').doc(userId));

    var classField = userDoc.get('class'); // Use get to access the field
    if (classField == null) {
      return []; // Return an empty list if the class field is null
    } else if (classField is DocumentReference) {
      // Handle the case where the class field is a reference
      classId = classField.path;
    } else {
      throw Exception("Unexpected value type for class field");
    }
    List<DocumentSnapshot> events = await data.getEvents(classId);

    // Use Future.wait to fetch all data concurrently
    List<Future<Map<String, dynamic>>> eventFutures = events.map((event) async {
      var eventData = event.data() as Map<String, dynamic>;

      DateTime date = (eventData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MM-dd – kk:mm').format(date);

      return {
        'date': formattedDate,
        'desc': eventData['desc'],
        'name': eventData['name'],
        'imageUrl': eventData['imageUrl'],
        'organizer': eventData['organizer']
      };
    }).toList();

    // Await all futures to complete
    return await Future.wait(eventFutures);
  }
}
