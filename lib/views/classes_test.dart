import 'package:flutter/material.dart';

import '../widgets/school_classes_creating.dart';

class ClassesTest extends StatefulWidget {
  const ClassesTest({super.key});



  @override
  State<ClassesTest> createState() => _ClassesTestState();
}

class _ClassesTestState extends State<ClassesTest> {
  final List<TextEditingController> _classControllers = [];
  // Future<void> _saveLessonSpots() async {
  //     try {
  //       LessonSpotService lessonSpotService = LessonSpotService();
  //       await lessonSpotService.saveLessonSpots(lessonsPerDay);
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Lesson spots successfully saved.')),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error saving lesson spots: $e')),
  //       );
  //     }
  //
  //   }


  void _deleteClassField(int index) {
    setState(() {
      if (index >= 0 && index < _classControllers.length) {
        _classControllers.removeAt(index);
      }
    });
  }

  void _addNewClassField() {
    setState(() {
      _classControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('testing'),
      ),
      body: Container(
        width: double.infinity,
        child: SchoolClassesCreating(
          classControllers: _classControllers,
          onAddClass: _addNewClassField,
          onDeleteClass: _deleteClassField,
        ),
      ),
    );
  }
}
