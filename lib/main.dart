import 'package:google_sign_in/google_sign_in.dart';
import 'package:scientia/components/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scientia/pages/authentication_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/api/google_signin_api.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Scentia());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
  ));
}

class Scentia extends StatefulWidget {
  const Scentia({super.key});

  @override
  _ScentiaState createState() => _ScentiaState();
}

class _ScentiaState extends State<Scentia> {
  //GoogleSignInAccount? currentUser; // Define a variable to hold the user object
  @override
  // void initState() {
  //   super.initState();
  //   _loadSavedUser(); // Load saved user on initialization
  // }

  // Future<void> _loadSavedUser() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? savedUserId = prefs.getString('userId'); // Change 'userId' to a unique key
  //
  //   if (savedUserId != null) {
  //     // Load user data based on the saved ID
  //     // For example, fetch the user using GoogleSignInApi
  //     final GoogleSignInAccount? user = await GoogleSignInApi.fetchUserData(savedUserId);
  //
  //     if (user != null) {
  //       setState(() {
  //         currentUser = user;
  //       });
  //     }
  //   }
  // }

  // Function to handle login and navigation
  // Future<void> handleLogin() async {
  //   final GoogleSignInAccount? user = await GoogleSignInApi.login();
  //   if (user != null) {
  //     setState(() {
  //       currentUser = user; // Set the currentUser when logged in
  //     });
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => BottomBar(user: user), // Passing the user object
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Test',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home:AuthenticationPage(),// Pass the function to the AuthenticationPage
    );
  }
}







// Future<void> _handleSignIn() async {
//   try {
//     user = await GoogleSignInApi.login();
//
//     GoogleSignInAuthentication? googleSignInAuthentication = await user?.authentication;
//
//     setState(() {
//       accessToken = googleSignInAuthentication?.accessToken;
//     });
//   } catch (error) {
//     print(error);
//   }
// }
