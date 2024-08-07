import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class EventsModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchEvents() async {
    String? userId = AuthService.getCurrentUserId();

    // Get the user's document reference
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
    List<DocumentSnapshot> events = await data.getEvents(userDocRef);

    // Use Future.wait to fetch all data concurrently
    List<Future<Map<String, dynamic>>> eventFutures = events.map((event) async {
      var eventData = event.data() as Map<String, dynamic>;

      DateTime date = (eventData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('MM-dd – kk:mm').format(date);

      return {
        'address': eventData['address'],
        'date': formattedDate,
        'desc': eventData['desc'],
        'name': eventData['name'],
        'imageUrl': eventData['imageUrl'],
      };
    }).toList();

    // Await all futures to complete
    return await Future.wait(eventFutures);
  }
}
