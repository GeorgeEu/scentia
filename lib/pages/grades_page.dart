import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/grades/grades/grades.dart';
import '../components/grades/td_grades/todays_grades.dart';
import '../data/grades_data/grades_data.dart';
import '../data/grades_data/td_grades_data.dart';

class Grades_Page extends StatefulWidget {
  const Grades_Page({Key? key}) : super(key: key);

  @override
  State<Grades_Page> createState() => _Grades_PageState();
}

enum Content { today, all }

class _Grades_PageState extends State<Grades_Page> {
  var grades = GradesData();
  var td_grades = TdGradesData();
  Content selectedContent = Content.today;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffefeff4),
        actions: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(bottom: 4, top: 4),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SegmentedButton<Content>(
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.only(left: 12, right: 12)),
                    ),
                    segments: const <ButtonSegment<Content>>[
                      ButtonSegment<Content>(
                          value: Content.today, label: Text('Recent')),
                      ButtonSegment<Content>(
                        value: Content.all,
                        label: Text('All'),
                      ),
                    ],
                    selected: <Content>{selectedContent},
                    onSelectionChanged: (Set<Content> newSelection) {
                      setState(() {
                        selectedContent = newSelection.first;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        color: const Color(0xffefeff4),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  if (selectedContent == Content.today)
                    TdGrades(td_grades.getTdGrades()),
                  if (selectedContent == Content.all)
                    Grades(grades.getGrades()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
