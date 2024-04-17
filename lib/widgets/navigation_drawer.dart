import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scientia/widgets/attendance/attendance_calendar.dart';
import 'package:scientia/views/authentication_page.dart';
import 'package:scientia/views/events_page.dart';
import 'package:scientia/views/exams_page.dart';
import 'package:scientia/views/settings_page.dart';
import 'package:flutter/material.dart'; // Make sure this is the correct path to your GoogleSignInApi
import 'package:scientia/services/auth_services.dart';
import '../views/grades_page.dart';
import '../views/homework_page.dart';
import '../views/schedule_page.dart';
import '../views/substitutions_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Drawer(
      backgroundColor: Color(0xFFF7F7FA),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(color: Colors.transparent),
            ),
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFA4A4FF),
                ),
                padding: EdgeInsets.fromLTRB(16, 16, 0, 8),
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
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            Text(
                              user.email!,
                              style: TextStyle(fontSize: 14, color: Colors.white70),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await AuthService().logout();
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => AuthenticationPage(),
                            ));
                          },
                          icon: Icon(Icons.logout_rounded, color: Colors.white,),
                        )
                      ],
                    ),
                  ],
                )
            ),
          ),
          ListTile(
            leading: Icon(Icons.school_rounded),
            title: Text(
              'Exams',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ExamsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.grading_rounded),
            title: Text(
              'Attendance',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AttendanceCalendar()));
            },
          ),
          ListTile(
            leading: Icon(Icons.change_circle_rounded),
            title: Text(
              'Substitutions',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SubstitutionsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event_rounded),
            title: Text(
              'Events',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => EventsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_rounded),
            title: Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month_rounded),
            title: Text(
              'Schedule',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Schedule_Page()));
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark_border_rounded),
            title: Text(
              'Homework',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Homework_Page()));
            },
          ),
          ListTile(
            leading: Icon(Icons.grade_rounded),
            title: Text(
              'Grades',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GradesPage()));
            },
          )
          // Add more ListTiles for other navigation items.
        ],
      ),
    );
  }
}
