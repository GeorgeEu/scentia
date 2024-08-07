import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_services.dart';

class HwCreatingPage extends StatefulWidget {
  const HwCreatingPage({super.key});

  @override
  State<HwCreatingPage> createState() => _HwCreatingPageState();
}

class _HwCreatingPageState extends State<HwCreatingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();
  DateTime? _endAt;
  String? _selectedClass;
  String? _selectedSubject;
  String? _teacherName;
  List<DropdownMenuItem<String>> _classDropdownItems = [];
  List<DropdownMenuItem<String>> _subjectDropdownItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      // Get current user ID
      String? currentUserId = AuthService.getCurrentUserId();

      // Fetch the user's school and name
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .doc('/users/$currentUserId/account/permission')
          .get();
      DocumentReference schoolRef = userDoc.get('school');
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .doc('/users/$currentUserId')
          .get();
      String teacherName = userInfo.get('name');

      // Fetch the classes for the school
      QuerySnapshot classSnapshot = await FirebaseFirestore.instance
          .collection('${schoolRef.path}/classes')
          .get();

      // Fetch the subjects
      QuerySnapshot subjectSnapshot = await FirebaseFirestore.instance
          .collection('subjects')
          .get();

      // Populate the dropdown items for classes and subjects
      List<DropdownMenuItem<String>> classItems = classSnapshot.docs
          .map((doc) => DropdownMenuItem<String>(
        value: doc.reference.path,
        child: Text(doc['name']),
      ))
          .toList();
      List<DropdownMenuItem<String>> subjectItems = subjectSnapshot.docs
          .map((doc) => DropdownMenuItem<String>(
        value: doc.reference.path,
        child: Text(doc['name']),
      ))
          .toList();

      setState(() {
        _classDropdownItems = classItems;
        _subjectDropdownItems = subjectItems;
        _teacherName = teacherName;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  void _createHomework() async {
    if (_formKey.currentState!.validate()) {
      final homeworkCollection = FirebaseFirestore.instance.collection('homework');

      final newHomework = {
        'class': FirebaseFirestore.instance.doc(_selectedClass!),
        'endAt': Timestamp.fromDate(_endAt!),
        'subject': FirebaseFirestore.instance.doc(_selectedSubject!),
        'task': _taskController.text,
        'teacher': _teacherName,
      };

      try {
        await homeworkCollection.add(newHomework);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Homework added successfully')));
        Navigator.pop(context); // Close the form after successful submission
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add homework: $error')));
      }
    }
  }

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
          'New Homework',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: InputDecoration(labelText: 'Class'),
                items: _classDropdownItems,
                onChanged: (value) {
                  setState(() {
                    _selectedClass = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a class';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: InputDecoration(labelText: 'Subject'),
                items: _subjectDropdownItems,
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a subject';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _taskController,
                decoration: InputDecoration(labelText: 'Task'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the task';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_endAt == null ? 'End At' : _endAt.toString()),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _endAt) {
                    setState(() {
                      _endAt = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createHomework,
                child: Text('Create Homework'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
