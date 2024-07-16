import 'package:scientia/widgets/substitutions/substitute_teachers.dart';
import 'package:scientia/services/firestore_data.dart';
import 'package:scientia/services/substitute_data/substitutions_data.dart';
import 'package:flutter/material.dart';

import '../services/auth_services.dart';


class SubstitutionsPage extends StatefulWidget {
  const SubstitutionsPage({super.key});

  @override
  State<SubstitutionsPage> createState() => _SubstitutionsPageState();
}

class _SubstitutionsPageState extends State<SubstitutionsPage> {
  var data = FirestoreData();
  String? userId = AuthService.getCurrentUserId();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffefeff4),
        appBar: AppBar(
          backgroundColor: Color(0xFFA4A4FF),
          actions: [
            IconButton(
              icon: Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () {
                // showSearch(context: context, delegate: );
              },
            )
          ],
          leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Substitutions',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
          // titleSpacing: 0,
        ),
        body: SubstituteTeachers(data.getSubstitutions(userId!))
    );
  }
}

