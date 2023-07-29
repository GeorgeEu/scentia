import 'package:flutter/material.dart';

class SubstitutionsPage extends StatefulWidget {
  const SubstitutionsPage({Key? key}) : super(key: key);

  @override
  State<SubstitutionsPage> createState() => _SubstitutionsPageState();
}

class _SubstitutionsPageState extends State<SubstitutionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Substitutions',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
              )
            ],
          ),
        ),
      )
    );
  }
}
