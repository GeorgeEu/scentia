import 'package:firebase_auth/firebase_auth.dart';
import 'package:scientia/components/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:scientia/pages/bottom_bar_pages/main_page.dart';
import 'firebase_options.dart';
import 'package:scientia/pages/authentication_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Scentia());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFFf2f2f2),
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
            return Main_Page(); // You can replace this with your desired content
          }
        } else {
          // Still connecting to the authentication state, show loading or splash screen
          return CircularProgressIndicator();
        }
      },
    );
  }
}

