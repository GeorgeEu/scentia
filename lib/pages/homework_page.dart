import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/home_work/full_hw/home_work.dart';
import '../components/home_work/hw_for_tmr/homework_for_tmr.dart';
import '../data/home_work_data/home_work_data.dart';
import '../data/home_work_data/tmr_hw_data.dart';

class Homework_Page extends StatefulWidget {
  const Homework_Page({Key? key}) : super(key: key);

  @override
  State<Homework_Page> createState() => _Homework_PageState();
}
enum Content { dueTomorrow, theRemaining }

class _Homework_PageState extends State<Homework_Page> {
  var tasks = HomeWorkData();
  var tmr_task = TmrHomeWorkData();
  Content selectedContent = Content.dueTomorrow;

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
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SegmentedButton<Content>(
                    showSelectedIcon: false,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 12,right: 12))
                    ),
                    segments: const <ButtonSegment<Content>>[
                      ButtonSegment<Content>(
                          value: Content.dueTomorrow,
                          label: Text('Due Tomorrow')
                      ),
                      ButtonSegment<Content>(
                        value: Content.theRemaining,
                        label: Text('The Remaining'),
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
                  if (selectedContent == Content.dueTomorrow)
                    TmrHomeWork(tmr_task.getTmrHomeWork()),
                  if (selectedContent == Content.theRemaining)
                    HomeWork(tasks.getHomeWork()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}