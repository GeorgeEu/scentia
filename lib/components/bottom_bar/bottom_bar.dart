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

  int _selectedIndex = 0;
  List<Widget> _widgetOptions() => [
    Main_Page(),
    const Schedule_Page(),
    const Homework_Page(),
    const Grades_Page(),
  ];

  @override
  Widget build(BuildContext context) {

    final List<Widget> widgetOptions = _widgetOptions();
    return Scaffold(
      body: widgetOptions[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.blue.shade100,
        backgroundColor: const Color(0xFFf2f2f2),
        height: 60,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: "Schedule",
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
