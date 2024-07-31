import 'package:firebase_auth/firebase_auth.dart';
import 'package:scientia/views/attendance_page.dart';
import 'package:scientia/widgets/attendance/attendance_calendar.dart';
import 'package:scientia/views/authentication_page.dart';
import 'package:scientia/views/events_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/views/exams_page.dart';
import 'package:scientia/views/settings_page.dart';
import 'package:flutter/material.dart'; // Make sure this is the correct path to your GoogleSignInApi
import 'package:scientia/services/auth_services.dart';
import '../views/grades_page.dart';
import '../views/homework_page.dart';
import '../views/schedule_page.dart';
import '../views/substitutions_page.dart';

class MyDrawer extends StatefulWidget {
  final List<Map<String, dynamic>> homework;
  final List<Map<String, dynamic>> grades;
  final List<Map<String, dynamic>> allGrades;
  final List<Map<String, dynamic>> attendance;
  final List<DocumentSnapshot> events;
  const MyDrawer({super.key, required this.homework, required this.grades, required this.allGrades, required this.events, required this.attendance});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
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
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
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
                                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            Text(
                              user.email!,
                              style: const TextStyle(fontSize: 14, color: Colors.white70),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await AuthService().logout();
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const AuthenticationPage(),
                            ));
                          },
                          icon: const Icon(Icons.logout_rounded, color: Colors.white,),
                        )
                      ],
                    ),
                  ],
                )
            ),
          ),
          ListTile(
            leading: const Icon(Icons.school_rounded),
            title: const Text(
              'Exams',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const ExamsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grading_rounded),
            title: const Text(
              'Attendance',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AttendancePage(attendance: widget.attendance)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.change_circle_rounded),
            title: const Text(
              'Substitutions',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SubstitutionsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_rounded),
            title: const Text(
              'Events',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EventsPage(events: widget.events)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text(
              'Schedule',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SchedulePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border_rounded),
            title: const Text(
              'Homework',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HomeworkPage(homework: widget.homework)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grade_rounded),
            title: const Text(
              'Grades',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GradesPage(allGrades: widget.allGrades)));
            },
          )
          // Add more ListTiles for other navigation items.
        ],
      ),
    );
  }
}
