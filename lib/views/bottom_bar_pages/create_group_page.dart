import 'package:flutter/material.dart';

import '../../widgets/text_fields/create_group_text_field.dart';
import '../../widgets/text_fields/search_people_text_field.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New group',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () {Navigator.pop(context);}
        ),
      ),
      body: Container(
        color: const Color(0xffefeff4),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Column(
            children: [
              CreateGroupTextField(),
              SearchPeopleTextField()
            ],
          ),
        ),
      ),
    );
  }
}
