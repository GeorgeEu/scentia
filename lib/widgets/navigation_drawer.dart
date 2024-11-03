import 'package:firebase_auth/firebase_auth.dart';
import 'package:scientia/views/attendance_page.dart';
import 'package:scientia/views/authentication_page.dart';
import 'package:scientia/views/classes_test.dart';
import 'package:scientia/views/events_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/views/exams_page.dart';
import 'package:scientia/views/settings_page.dart';
import 'package:flutter/material.dart'; // Make sure this is the correct path to your GoogleSignInApi
import 'package:scientia/services/auth_services.dart';
import 'package:scientia/widgets/owner_balance_widget.dart';
import '../views/grades_page.dart';
import '../views/homework_page.dart';
import '../views/schedule_page.dart';
import '../views/substitutions_page.dart';

class MyDrawer extends StatefulWidget {
  final List<Map<String, dynamic>> homework;
  final List<Map<String, dynamic>> grades;
  final List<Map<String, dynamic>> allGrades;
  final List<Map<String, dynamic>> attendance;
  final List<Map<String, dynamic>> events;
  final List<Map<String, dynamic>> offers;
  final int balance;
  final String userStatus;
  final Map<String, double> absencePercentageMap;

  MyDrawer({
    super.key,
    required this.grades,
    required this.allGrades,
    required this.offers,
    required this.balance,
    required this.events,
    required this.absencePercentageMap,
    required this.homework,
    required this.attendance,
    required this.userStatus,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF7F7FA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(color: Colors.transparent),
            ),
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFA4A4FF),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName!,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Text(
                            user.email!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          await AuthService().logout();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const AuthenticationPage()));
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Conditional ListTiles based on userStatus
          ..._buildUserSpecificTiles(),
        ],
      ),
    );
  }

  List<Widget> _buildUserSpecificTiles() {
    List<Widget> tiles = [];

    switch (widget.userStatus) {
      case "student":
        tiles.addAll([
          ListTile(
            leading: const Icon(Icons.school_rounded),
            title: const Text(
              'Exams',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ExamsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grade_rounded),
            title: const Text(
              'Grades',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      GradesPage(allGrades: widget.allGrades)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border_rounded),
            title: const Text(
              'Homework',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      HomeworkPage(homework: widget.homework)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grading_rounded),
            title: const Text(
              'Attendance',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AttendancePage(
                      attendance: widget.attendance,
                      absencePercentageMap: widget.absencePercentageMap)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text(
              'Schedule',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SchedulePage(userStatus: widget.userStatus)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.change_circle_rounded),
            title: const Text(
              'Substitutions',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SubstitutionsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    userStatus: widget.userStatus,
                    offers: widget.offers,
                    balance: widget.balance,
                    userImage: user.photoURL!,
                    userName: user.displayName!,
                    userEmail: user.email!,
                  )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_rounded),
            title: const Text(
              'Events',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EventsPage(events: widget.events)));
            },
          ),
        ]);
        break;

      case "teacher":
        tiles.addAll([
          ListTile(
            leading: const Icon(Icons.grading_rounded),
            title: const Text(
              'Attendance',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AttendancePage(
                      attendance: widget.attendance,
                      absencePercentageMap: widget.absencePercentageMap)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.change_circle_rounded),
            title: const Text(
              'Substitutions',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SubstitutionsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    userStatus: widget.userStatus,
                    offers: widget.offers,
                    balance: widget.balance,
                    userImage: user.photoURL!,
                    userName: user.displayName!,
                    userEmail: user.email!,
                  )));
            },
          ),
        ]);
        break;

      case "owner":
        tiles.addAll([
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    userStatus: widget.userStatus,
                    offers: widget.offers,
                    balance: widget.balance,
                    userImage: user.photoURL!,
                    userName: user.displayName!,
                    userEmail: user.email!,
                  )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text(
              'Test',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ClassesTest()));
            },
          )
        ]);
        break;

      default:
        tiles.add(
          ListTile(
            title: const Text(
              'No specific access',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        );
        break;
    }

    return tiles;
  }
}
