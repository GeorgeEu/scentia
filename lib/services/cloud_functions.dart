import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class CloudFunctions {
  // Getting the current user
  final User? user = FirebaseAuth.instance.currentUser;

  Future<String?> getLogs(String schoolId) async {
    // Ensure the user is not null
    if (user == null) {
      throw Exception('User is not signed in');
    }

    // Get the ID token for the current user
    final String? idToken = await user?.getIdToken();

    // Define the URL for the Cloud Function
    final url = Uri.parse('https://us-central1-scentia-396314.cloudfunctions.net/getLogs');

    // Send a POST request to the Cloud Function
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'token': idToken,
        'schoolId': schoolId,
      }),
    );

    // Check the response status code
    if (response.statusCode == 200) {
      // Parse the response body as JSON
      final data = jsonDecode(response.body);
      // Return the logs from the response
      return data['logs'];
    } else {
      // Throw an exception if the request failed
      throw Exception('Failed to fetch logs');
    }
  }
}
