import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/auth_services.dart';
import '../services/firestore_data.dart';

class SubstModel {
  final FirestoreData data = FirestoreData();

  Future<List<Map<String, dynamic>>> fetchSubst() async {
    String? userId = AuthService.getCurrentUserId();

    List<DocumentSnapshot> substitutions = await data.getSubstitutions(userId!);
    List<Map<String, dynamic>> tempSubstItems = [];

    for (var substitution in substitutions) {
      var substData = substitution.data() as Map<String, dynamic>;

      // Retrieve subject from nested reference
      DocumentSnapshot subjectDoc = await data.getDoc(substData['subject']);
      DocumentReference nestedSubjectRef = subjectDoc['subject'] as DocumentReference;
      DocumentSnapshot nestedSubjectDoc = await nestedSubjectRef.get();
      String subjectName = nestedSubjectDoc['name'];

      // Retrieve substituted name
      DocumentSnapshot substitutedDoc = await data.getDoc(substData['substituted']);
      String substitutedName = substitutedDoc['name'];

      // Retrieve substituter name
      DocumentSnapshot substituterDoc = await data.getDoc(substData['substituter']);
      String substituterName = substituterDoc['name'];

      // Format date
      DateTime date = (substData['date'] as Timestamp).toDate();
      String formattedDate = DateFormat('EEEE, MM-dd HH:mm').format(date);


      // Add to the list
      tempSubstItems.add({
        'date': formattedDate,
        'subject': subjectName,
        'substituted': substitutedName,
        'substituter': substituterName,
      });
    }

    return tempSubstItems;
  }
}
