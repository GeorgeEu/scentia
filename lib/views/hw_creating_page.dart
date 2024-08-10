import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scientia/widgets/st_dropdown_field.dart';
import 'package:scientia/widgets/st_snackbar.dart';
import '../widgets/empty_state_page.dart';
import '../widgets/st_form_textfield.dart';

class HwCreatingPage extends StatefulWidget {
  final List<DropdownMenuItem<String>> classDropdownItems;
  final List<DropdownMenuItem<String>> subjectDropdownItems;
  final String teacherName;
  HwCreatingPage({
    super.key,
    required this.classDropdownItems,
    required this.subjectDropdownItems,
    required this.teacherName,
  });

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

  @override
  void initState() {
    super.initState();
    _teacherName = widget.teacherName;
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
        ScaffoldMessenger.of(context).showSnackBar(StSnackBar(message: 'Homework sent successfully'));
        Navigator.pop(context); // Close the form after successful submission
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(StSnackBar(message: 'Failed to add homework: $error'));
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
      body: widget.classDropdownItems.isEmpty || widget.subjectDropdownItems.isEmpty
          ? Center(
        child: EmptyStatePage(
          message: 'There is no classes or subjects available',
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 24),
                child: StDropdownField(
                  value: _selectedClass,
                  labelText: 'Class',
                  items: widget.classDropdownItems,
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
              ),
              StDropdownField(
                value: _selectedSubject,
                labelText: 'Subject',
                items: widget.subjectDropdownItems,
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
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: StFormTextfield(
                  controller: _taskController,
                  labelText: 'Task',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the task';
                    }
                    return null;
                  },
                ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border roundness
                  ),
                  elevation: 0, // Removes shadow
                ),
                child: Text('Create Homework'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
