import 'package:flutter/material.dart';
import 'package:scientia/widgets/bottom_bar/bottom_bar.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:scientia/views/bottom_bar_pages/main_page.dart';
import 'package:scientia/services/auth_services.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    var hiEmoji = parser.get('wave');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, top: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/s_logo.png',
                height: 48,
                width: 44,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Scentia!',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text.rich(
                  TextSpan(
                    text: 'Scientia is a school tool for ',
                    style: TextStyle(fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'learning',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ',',
                      ),
                      TextSpan(
                        text: ' communication',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'organization',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' '),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AuthService().signInwithGoogle(); // Wait for sign-in to complete
                  Navigator.pushReplacement(
                    // Use pushReplacement to replace the current route
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Main_Page()), // Replace with your BottomBar widget
                  );
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.grey.shade300),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  // Change background color to grey
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color:
                              Colors.grey.shade300), // Set border radius to 8
                    ),
                  ),
                  alignment: Alignment.center,
                  // Align the content to the center
                  elevation: MaterialStateProperty.all(0.1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/google_logo.png',
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Continue with Google',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.grey.shade300),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    // Change background color to grey
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            color:
                                Colors.grey.shade300), // Set border radius to 8
                      ),
                    ),
                    alignment: Alignment.center,
                    // Align the content to the center
                    elevation: MaterialStateProperty.all(0.1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/apple_logo.png',
                        width: 16,
                      ), // Add some spacing between the image and text
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Continue with Apple',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  "If you don't have a Google or Apple account, you'll have to create one",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
