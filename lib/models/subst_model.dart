import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class SubstModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchSubst() async {
    String? userId = AuthService.getCurrentUserId();
    if (userId == null) {
      return [];
    }

    List<DocumentSnapshot> substitutions = await data.getSubstitutions(userId);

    // Use Future.wait to fetch all data concurrently
    List<Future<Map<String, dynamic>>> substFutures = substitutions.map((substitution) async {
      var substData = substitution.data() as Map<String, dynamic>;

      // Fetch subject, substituted, and substituter documents concurrently
      Future<DocumentSnapshot> subjectDocFuture = data.getDoc(substData['subject']);
      Future<DocumentSnapshot> substitutedDocFuture = data.getDoc(substData['substituted']);
      Future<DocumentSnapshot> substituterDocFuture = data.getDoc(substData['substituter']);

      DocumentSnapshot subjectDoc = await subjectDocFuture;
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      DocumentSnapshot substitutedDoc = await substitutedDocFuture;
      String substitutedName = substitutedDoc['name'];

      DocumentSnapshot substituterDoc = await substituterDocFuture;
      String substituterName = substituterDoc['name'];

      DateTime date = (substData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('EEEE, MM-dd HH:mm').format(date);

      return {
        'date': formattedDate,
        'subject': subjectName,
        'substituted': substitutedName,
        'substituter': substituterName,
      };
    }).toList();

    // Await all futures to complete
    return await Future.wait(substFutures);
  }
}
