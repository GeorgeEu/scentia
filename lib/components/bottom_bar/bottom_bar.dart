import 'package:google_sign_in/google_sign_in.dart';
import 'package:scientia/pages/bottom_bar_pages/main_page.dart';
import 'package:scientia/pages/bottom_bar_pages/schedule_page.dart';
import 'package:flutter/material.dart';
import '../../pages/bottom_bar_pages/grades_page.dart';
import '../../pages/bottom_bar_pages/homework_page.dart';
import 'homework_function.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});



  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
                  child: Row(
                    children: [
                      Text(
                        'Create',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 28,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.backpack_rounded),
                  title: Text('Create a homework'),
                  onTap: () {
                    showHomeworkBottomSheet(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mail_rounded),
                  title: Text('Send a message'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.announcement_rounded),
                  title: Text('Make an announcement'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.border_color_rounded),
                  title: Text('Give a grade'),
                  onTap: () {},
                ),
              ],
            ),
          );
        });
  }

  int _selectedIndex = 0;
  List<Widget> _widgetOptions() => [
    Main_Page(),
    const Schedule_Page(),
    Container(),
    const Homework_Page(),
    const Grades_Page(),
  ];

  @override
  Widget build(BuildContext context) {

    final List<Widget> widgetOptions = _widgetOptions();
    return Scaffold(
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 64,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: "Schedule",
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: FloatingActionButton(
              onPressed: () {
                _showBottomSheet(context);
              },
              elevation: 0,
              child: Icon(Icons.add),
            ),
          ),
          NavigationDestination(
            icon: Icon(Icons.book),
            label: "Homework",
          ),
          NavigationDestination(
            icon: Icon(Icons.text_increase_rounded),
            label: "Grades",
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
