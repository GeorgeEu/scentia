import 'package:scientia/components/substitutions/substitute_teachers.dart';
import 'package:scientia/data/firestore_data.dart';
import 'package:scientia/data/substitute_data/substitutions_data.dart';
import 'package:flutter/material.dart';


class SubstitutionsPage extends StatefulWidget {
  const SubstitutionsPage({Key? key}) : super(key: key);

  @override
  State<SubstitutionsPage> createState() => _SubstitutionsPageState();
}

class _SubstitutionsPageState extends State<SubstitutionsPage> {
  var data = FirestoreData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Container(
          color: const Color(0xffefeff4),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SubstituteTeachers(data.getSubstitutions()),
              ],
            ),
          ),
        )
    );
  }
}

