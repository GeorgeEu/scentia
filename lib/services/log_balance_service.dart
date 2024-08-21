import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogBalanceService {
  final HttpsCallable _processLogsFunction = FirebaseFunctions.instance.httpsCallable('processLogsAndUpdateBalance');
  final user = FirebaseAuth.instance.currentUser;

  Future<void> callProcessLogsFunction(String schoolId) async {
    try {
      final idToken = await user?.getIdToken();
      if (user != null) {

        // Call the Cloud Function with only the token
        await _processLogsFunction.call({
          'token': idToken,
          'schoolId': schoolId
        });

        print("Logs processed successfully.");
      } else {
        print("User is not authenticated.");
      }
    } catch (error) {
      print("Error processing logs: $error");
    }
  }
}