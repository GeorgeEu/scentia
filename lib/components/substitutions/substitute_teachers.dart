import 'package:flutter/material.dart';
import 'package:card_test/components/substitutions/substitute_teacher.dart';

class SubstituteTeachers extends StatelessWidget {
  final List _substitutions;

  const SubstituteTeachers(this._substitutions);

  @override
  Widget build(BuildContext context) {
    var eventsCount = _substitutions.length;
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Column(
        children: [
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: eventsCount,
            itemBuilder: (context, index) {
              return SubstituteTeacher(_substitutions[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 0.5,
                height: 1,
                // indent: 8.0,
              );
            },
          ),
        ],
      ),
    );
  }
}
