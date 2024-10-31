import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scientia/views/usage_history.dart';
import 'package:scientia/views/offers_widget.dart';

import '../widgets/custom_row.dart';

class BalancePage extends StatelessWidget {
  final int balance;
  final List<Map<String, dynamic>> offers;
  const BalancePage({super.key, required this.balance, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: SvgPicture.asset(
              width: 125,
              height: 125,
              'assets/s_logo.svg', // Path to your SVG file
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Scentia Tokens',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  height: 1,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 30, right: 30),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    'Only pay for the services you use, whenever you need them. ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: 'More about Tokens ',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.bottom,
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 14, // Adjust the size as needed
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        balance.toString(),
                        style: TextStyle(
                            fontSize: 24,
                            height: 1,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      'τ',
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  child: Text(
                    'your balance',
                    style: TextStyle(fontSize: 13, color: Colors.grey, height: 1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(

                      onPressed: () {
                        _showBottomSheet(context); // Call the method here
                      },
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(Colors.blue.shade700),
                        backgroundColor: WidgetStateProperty.all(Colors.blue),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(vertical: 16.0)),
                        alignment: Alignment.center,
                        elevation: WidgetStateProperty.all(0.1),
                      ),
                      child: Text(
                        'TOP UP',
                        style: TextStyle(color: Colors.white, height: 1),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32, right: 32, top: 18),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), // Same border radius
                      color: Colors.white, // Same background color
                      border: Border.all(
                        color: Colors.grey.shade300, // Set border color
                        width: 1// Border width
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomRow(
                          padding: EdgeInsets.only(left: 10),
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 150),
                                reverseTransitionDuration: Duration(milliseconds: 100),
                                pageBuilder: (context, animation, secondaryAnimation)
                                => UsageHistory(), // Your BalancePage
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);  // Slide in from the right
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                size: 25,
                              ),
                            ),
                            Text(
                              'Crediting Funds',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 0,
                          thickness: 1,
                          indent: 45,
                          color: Colors.grey.shade300,
                        ),
                        CustomRow(
                          padding: EdgeInsets.only(left: 10),
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 150),
                                reverseTransitionDuration: Duration(milliseconds: 100),
                                pageBuilder: (context, animation, secondaryAnimation)
                                => UsageHistory(), // Your BalancePage
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);  // Slide in from the right
                                  const end = Offset.zero;
                                  const curve = Curves.ease;

                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.history_rounded,
                                size: 25,
                              ),
                            ),
                            Text(
                              'Usage History',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                height: 1,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
              child: Text(
                'Choose package',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade600
                ),
              ),
            ),
            OffersWidget(offers: offers),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 16, bottom: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      'By proceeding and purchasing Tokens, you agree with the',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: ' Terms and Conditions.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
