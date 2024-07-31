// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
//
//
// class AttendanceCalendar extends StatefulWidget {
//   const AttendanceCalendar({Key? key}) : super(key: key);
//
//   @override
//   State<AttendanceCalendar> createState() => _AttendanceCalendarState();
// }
//
// class _AttendanceCalendarState extends State<AttendanceCalendar> {
//   late DateTime selectedDay;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDay = DateTime.now();
//   }
//
//   void _showAttendanceBottomSheet(DateTime day) {
//     final attendance = _attendance.getDailyAttendance(day.millisecondsSinceEpoch);
//     showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return makeDismissible(
//           child: DraggableScrollableSheet(
//             initialChildSize: 0.70,
//             maxChildSize: 0.95,
//             minChildSize: 0.5,
//             builder: (_, controller) => Container(
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(16))
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                         border: Border(
//                             bottom: BorderSide(
//                                 width: 1,
//                                 color: Colors.grey.shade300
//                             )
//                         )
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 24, bottom: 8),
//                       child: Text(
//                         'Attendance',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 14
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView(
//                       controller: controller,
//                       children: attendance.map((att) {
//                         String displayText;
//
//                         if (att['Absence'] == 0) {
//                           displayText = 'Late: ${att['Late']}';
//                         } else {
//                           displayText = 'Absence: ${att['Absence']}';
//                         }
//
//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8, right: 4, left: 4),
//                           child: ListTile(
//                             title: Text(
//                               att['Lesson'],
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 18,
//                               ),
//                             ),
//                             subtitle: Text(
//                               displayText,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//   Widget makeDismissible({required Widget child}) => GestureDetector(
//     behavior: HitTestBehavior.opaque,
//     onTap: () => Navigator.of(context).pop(),
//     child: GestureDetector(onTap: () {}, child: child),
//   );
//
//   // Method to show the bottom sheet with homework details
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFA4A4FF),
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//         title: Text(
//           'Attendance',
//           style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.white
//           ),
//         ),
//       ),
//       backgroundColor: const Color(0xffefeff4),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
//               child: TableCalendar(
//                 eventLoader: (day) => _attendance.getDailyAttendance(day.millisecondsSinceEpoch),
//                 calendarFormat: _calendarFormat,
//                 onFormatChanged: (format) {
//                   setState(() {
//                     _calendarFormat = format;
//                   });
//                 },
//                 firstDay: DateTime.utc(2010, 10, 16),
//                 lastDay: DateTime.utc(2030, 3, 14),
//                 focusedDay: selectedDay,
//                 selectedDayPredicate: (day) {
//                   return isSameDay(selectedDay, day);
//                 },
//                 // Inside your _CalendarState class
//                 onDaySelected: (selectedDay, focusedDay) {
//                   setState(() {
//                     this.selectedDay = selectedDay;
//                   });
//
//                   final dailyAttendance = _attendance.getDailyAttendance(selectedDay.millisecondsSinceEpoch);
//                   if (dailyAttendance.isNotEmpty) {
//                     _showAttendanceBottomSheet(selectedDay);
//                   }
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }