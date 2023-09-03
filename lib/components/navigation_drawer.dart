import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scientia/components/attendance/attendance_calendar.dart';
import 'package:scientia/pages/authentication_page.dart';
import 'package:scientia/pages/drawer_pages/events_page.dart';
import 'package:scientia/pages/drawer_pages/exams_page.dart';
import 'package:scientia/pages/drawer_pages/settings_page.dart';
import 'package:flutter/material.dart'; // Make sure this is the correct path to your GoogleSignInApi
import 'package:scientia/services/auth_services.dart';
import '../pages/drawer_pages/substitutions_page.dart';

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
      backgroundColor: Color(0xffefeff4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
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
                  Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName!,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            user.email!,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
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
                        icon: Icon(Icons.logout_rounded),
                      )
                    ],
                  ),
                ],
              )),
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
          // Add more ListTiles for other navigation items.
        ],
      ),
    );
  }
}
