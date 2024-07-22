import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/subst_model.dart'; // Import your SubstModel

class SubstituteTeachers extends StatefulWidget {
  SubstituteTeachers({super.key});

  @override
  _SubstituteTeachersState createState() => _SubstituteTeachersState();
}

class _SubstituteTeachersState extends State<SubstituteTeachers> {
  final SubstModel substModel = SubstModel();  // Create an instance of SubstModel

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: substModel.fetchSubst(),  // Use fetchSubst method
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, left: 24, bottom: 24, right: 24),
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),  // Add a separator
                itemBuilder: (context, index) {
                  final subst = snapshot.data![index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            subst['subject'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600, height: 1),
                          ),
                          Spacer(),
                          Text(
                            subst['date'],
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'To:',
                            style: TextStyle(

                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
                            child: Text(
                              subst['substituter'],
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500, height: 1),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              'From:',
                              style: TextStyle(
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              subst['substituted'],  // Use substituted name here
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
        return Center(
          child: Text('No substitutions found.'),
        );
      },
    );
  }
}
