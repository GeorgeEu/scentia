import 'package:flutter/material.dart';
import '../views/classes_test.dart';

class StatusCheckWidget extends StatelessWidget {
  final bool classesExist;
  final bool lessonsExist;

  StatusCheckWidget({
    required this.classesExist,
    required this.lessonsExist,
  });

  // Define the button style with state-dependent properties
  ButtonStyle customButtonStyle(Color backgroundColor, Color overlayColor) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(backgroundColor),
      overlayColor: WidgetStateProperty.all(overlayColor),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(vertical: 16.0),
      ),
      alignment: Alignment.center,
      elevation: WidgetStateProperty.all(0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If both exist, return an empty container
    if (classesExist && lessonsExist) {
      return Container();
    }

    // Determine which resource is missing and set button text accordingly
    String buttonText;
    if (!classesExist && !lessonsExist) {
      buttonText = 'Create Classes and Lesson';
    } else if (!classesExist) {
      buttonText = 'Create Classes';
    } else {
      buttonText = 'Create Lesson';
    }

    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 32),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
              const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 6),
              child: Text(
                'We are missing something',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  height: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
              child: Text(
                "Let's finish the setup and start our journey!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 32, right: 32),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the appropriate page based on what is missing
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 150),
                      reverseTransitionDuration:
                      Duration(milliseconds: 100),
                      pageBuilder: (context, animation,
                          secondaryAnimation) =>
                          ClassesTest(), // Replace with your actual widget
                      transitionsBuilder: (context, animation,
                          secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                style: customButtonStyle(
                  Colors.blue,
                  Colors.blue.shade700,
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
