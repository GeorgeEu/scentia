import 'package:scientia/services/firestore_data.dart';
import 'package:flutter/material.dart';
import 'package:scientia/widgets/exams/exams.dart';

import '../services/auth_services.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({Key? key}) : super(key: key);

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  String? userId = AuthService.getCurrentUserId();
  var exams = FirestoreData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F2F8),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
            backgroundColor: Color(0xFFA4A4FF),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Exams',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
        ),
        body: Exams(exams.getExams(userId!)));
  }
}
