import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserStatusWidget extends StatefulWidget {
  final Function(String) onStatusSelected; // Callback to pass the selected status to parent

  const UserStatusWidget({super.key, required this.onStatusSelected});

  @override
  _UserStatusWidgetState createState() => _UserStatusWidgetState();
}

class _UserStatusWidgetState extends State<UserStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 64, bottom: 32, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 72),
              child: SvgPicture.asset(
                width: 100,
                height: 100,
                'assets/s_logo.svg', // Path to your SVG file
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                "You're not invited to any institutions yet.",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Text(
                "You can ask the administration of your institution to invite you and just wait.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade400, // Line color
                    thickness: 0.9, // Line thickness
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'or',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.shade400, // Line color
                    thickness: 0.9, // Line thickness
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    widget.onStatusSelected(
                        'owner');
                  },
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.all(Colors.grey.shade300),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    // Change background color to grey
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            color:
                            Colors.grey.shade300), // Set border radius to 8
                      ),
                    ),
                    alignment: Alignment.center,
                    // Align the content to the center
                    elevation: WidgetStateProperty.all(0.1),
                  ),
                  child: Text(
                    'Create Institution',
                    style: TextStyle(color: Colors.black),
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

