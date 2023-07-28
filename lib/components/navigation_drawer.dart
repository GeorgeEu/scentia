import 'package:card_test/pages/drawer_pages/attendance_page.dart';
import 'package:card_test/pages/drawer_pages/events_page.dart';
import 'package:card_test/pages/drawer_pages/exams_page.dart';
import 'package:card_test/pages/drawer_pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xffefeff4),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.asset(
                        'assets/avatar.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'George Zanevski',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'g.zanevski@gmail.com',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey
                    ),
                  ),
                ],
              )),
          ListTile(
            leading: Icon(Icons.event_rounded),
            title: Text(
              'Events',
              style: TextStyle(
                fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventsPage()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.school_rounded),
            title: Text(
              'Exams',
              style: TextStyle(
                  fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExamsPage()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.grading_rounded),
            title: Text(
              'Attendance',
              style: TextStyle(
                  fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AttendancePage()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_rounded),
            title: Text(
              'Settings',
              style: TextStyle(
                  fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsPage()
              ));
            },
          ),
          // Add more ListTiles for other navigation items.
        ],
      ),
    );
  }
}
