import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/grade_creation_service.dart';
import '../utils/accounting.dart';
import '../widgets/custom_menu.dart';
import '../widgets/empty_state_page.dart';
import '../widgets/st_form_textfield.dart';
import '../widgets/st_snackbar.dart'; // Import the updated CustomDropdownMenu widget

class HwCreatingPage extends StatefulWidget {
  final List<Class> classes;
  final List<Subject> subjects;
  final String teacherName;

  HwCreatingPage({
    super.key,
    required this.classes,
    required this.subjects,
    required this.teacherName,
  });

  @override
  State<HwCreatingPage> createState() => _HwCreatingPageState();
}

class _HwCreatingPageState extends State<HwCreatingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _classController = TextEditingController(); // Separate controller
  final TextEditingController _subjectController = TextEditingController(); // Separate controller
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
      final homeworkCollection =
          FirebaseFirestore.instance.collection('homework');

      final newHomework = {
        'class': FirebaseFirestore.instance.doc(_selectedClass!),
        'endAt': Timestamp.fromDate(_endAt!),
        'subject': FirebaseFirestore.instance.doc(_selectedSubject!),
        'task': _taskController.text,
        'teacher': _teacherName,
      };

      try {
        await homeworkCollection.add(newHomework);

        // Log the write operation (1 document)
        await Accounting.detectAndStoreOperation(DatabaseOperation.dbWrite, newHomework.length);

        ScaffoldMessenger.of(context)
            .showSnackBar(StSnackBar(message: 'Homework sent successfully'));
        Navigator.pop(context); // Close the form after successful submission
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            StSnackBar(message: 'Failed to add homework: $error'));
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
      body: widget.classes.isEmpty || widget.subjects.isEmpty
          ? Center(
              child: EmptyStatePage(
                message: 'There are no classes or subjects available',
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32, top: 24),
                        child: CustomDropdownMenu<Class>(
                          label: const Text('Class'),
                          title: 'Select Class',
                          controller: _classController,
                          items: widget.classes,
                          itemTitleBuilder: (classItem) => classItem.name,
                          onSelected: (classItem) {
                            setState(() {
                              _selectedClass = classItem.id;
                            });
                          },
                        ),
                      ),
                      CustomDropdownMenu<Subject>(
                        controller: _subjectController,
                        label: Text('Subject'),
                        title: 'Select Subject',
                        items: widget.subjects,
                        itemTitleBuilder: (subjectItem) => subjectItem.name,
                        onSelected: (subjectItem) {
                          setState(() {
                            _selectedSubject = subjectItem.id;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
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
                        title:
                            Text(_endAt == null ? 'End At' : _endAt.toString()),
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _createHomework,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border roundness
                            ),
                            elevation: 0, // Removes shadow
                          ),
                          child: Text('Create Homework'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
