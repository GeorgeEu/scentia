import 'package:card_test/pages/main_page.dart';
import 'package:card_test/pages/schedule_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../pages/grades_page.dart';
import '../../pages/homework_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

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
                  padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 16),
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
                        icon: Icon(Icons.close),
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
                  onTap: () {},
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
        }
    );
  }
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Main_Page(),
    const Schedule_Page(),
    Container(),
    const Homework_Page(),
    const Grades_Page(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
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
                onPressed: (){
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
            icon: Icon(Icons.grade_rounded),
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