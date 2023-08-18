import 'package:scientia/data/exams_data/exams_data.dart';
import 'package:flutter/material.dart';
import 'package:scientia/components/exams/exams.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({Key? key}) : super(key: key);

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  @override
  Widget build(BuildContext context) {
    var exams = ExamsData();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {Navigator.pop(context);}
          ),
          title: Text(
            'Exams',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          color: const Color(0xffefeff4),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Exams(exams.getExams()),
              ],
            ),
          ),
        )
    );
  }
}
