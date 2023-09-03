import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scientia/components/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scientia/pages/authentication_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Card Test',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: AuthenticationWrapper()
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user == null) {
            // User is not signed in, show authentication page
            return AuthenticationPage();
          } else {
            // User is signed in, show your main content
            return BottomBar(); // You can replace this with your desired content
          }
        } else {
          // Still connecting to the authentication state, show loading or splash screen
          return CircularProgressIndicator();
        }
      },
    );
  }
}

