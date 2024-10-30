import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scientia/widgets/custom_column.dart';

import '../widgets/custom_row.dart';
import 'balance_page.dart';

class SettingsPage extends StatefulWidget {
  final String userImage;
  final int balance;
  final String userName;
  final String userEmail;
  final List<Map<String, dynamic>> offers;
  final String userStatus; // Add userStatus property

  const SettingsPage({
    Key? key,
    required this.userImage,
    required this.balance,
    required this.userName,
    required this.offers,
    required this.userEmail,
    required this.userStatus, // Pass userStatus in constructor
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color(0xFFA4A4FF),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(widget.userImage),
              ),
            ),
            Expanded(
              child: Text(
                widget.userName,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis),
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 24, left: 24, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Account',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                        height: 1),
                  ),
                ),
                CustomColumn(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        widget.userEmail,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            height: 1),
                      ),
                    ),
                    Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                          height: 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black,
                          height: 1),
                    ),
                  ),
                ),
                CustomRow(
                  padding: EdgeInsets.only(left: 24),
                  onTap: null,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 22),
                      child: Icon(
                        Icons.language,
                        color: Colors.grey,
                        size: 26,
                      ),
                    ),
                    Text(
                      'Language',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          height: 1),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 24),
                      child: Text(
                        'English',
                        style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          if (widget.userStatus == "owner") // Only show "My Tokens" if user is owner
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: Offset.zero,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomRow(
                    padding: EdgeInsets.only(left: 24),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 150),
                          reverseTransitionDuration:
                          Duration(milliseconds: 100),
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              BalancePage(
                                balance: widget.balance,
                                offers: widget.offers,
                              ),
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 26, left: 4),
                        child: Text(
                          'τ',
                          style: TextStyle(fontSize: 32, color: Colors.grey),
                        ),
                      ),
                      Text(
                        'My Tokens',
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
                    thickness: 0.5,
                    indent: 72,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
