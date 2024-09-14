import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/grade_creation_service.dart';
import '../utils/accounting.dart';
import '../widgets/custom_menu.dart';
import '../widgets/empty_state_page.dart';
import 'package:intl/intl.dart';
import '../widgets/st_snackbar.dart'; // Import the updated CustomDropdownMenu widget

class GradeCreatingPage extends StatefulWidget {
  final List<Subject> subjects;
  final String teacherName;
  List<Student> students = [];

  GradeCreatingPage({
    super.key,
    required this.students,
    required this.subjects,
    required this.teacherName,
  });

  @override
  State<GradeCreatingPage> createState() => _GradeCreatingPageState();
}

class _GradeCreatingPageState extends State<GradeCreatingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _studentController =
      TextEditingController(); // Separate controller
  final TextEditingController _subjectController =
      TextEditingController(); // Separate controller
  DateTime? _date;
  String? _selectedStudent;
  int? _selectedGrade;
  String? _selectedSubject;
  String? _teacherName;
  final List<DropdownMenuEntry<int>> gradeDropdownEntries = List.generate(
    6,
    (index) => DropdownMenuEntry(
      value: 5 + index, // Grade values from 5 to 10
      label: (5 + index).toString(), // Display the grade as text
    ),
  );

  @override
  void initState() {
    super.initState();
    _teacherName = widget.teacherName;
  }

  void _createGrade() async {
    if (_formKey.currentState!.validate()) {
      final gradesCollection = FirebaseFirestore.instance.collection('grades');

      final newGrade = {
        'uid': FirebaseFirestore.instance.doc(_selectedStudent!),
        'date': Timestamp.fromDate(_date!),
        'sid': FirebaseFirestore.instance.doc(_selectedSubject!),
        'grade': _selectedGrade,
        'teacher': _teacherName,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      try {
        await gradesCollection.add(newGrade);

        // Log the write operation (1 document)
        await Accounting.detectAndStoreOperation(
            DatabaseOperation.dbWrite, newGrade.length);

        ScaffoldMessenger.of(context)
            .showSnackBar(StSnackBar(message: 'Graded successfully'));
        Navigator.pop(context); // Close the form after successful submission
      } catch (error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(StSnackBar(message: 'Failed to grade: $error'));

        // Log the error to the console with additional context if needed
        print('/////////////////////////////////////');
        print("Failed to grade: $error");
        print(
            "Stack trace: $stackTrace"); // Optional: prints the stack trace for debugging
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
          'Grade',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: widget.students.isEmpty && widget.subjects.isEmpty
          ? Center(
              child: EmptyStatePage(
                message: 'There are no students or subjects available',
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
                        child: CustomDropdownMenu<Student>(
                          widthWidget: MediaQuery.of(context).size.width,
                          horizontalPadding: 16,
                          label: const Text('Students'),
                          title: 'Select Student',
                          controller: _studentController,
                          items: widget.students,
                          itemTitleBuilder: (student) => student.name,
                          onSelected: (student) {
                            setState(() {
                              _selectedStudent = student.id;
                            });
                          },
                        ),
                      ),
                      CustomDropdownMenu<Subject>(
                        widthWidget: MediaQuery.of(context).size.width,
                        controller: _subjectController,
                        horizontalPadding: 16,
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
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: DropdownMenu(
                                controller: _gradeController,
                                dropdownMenuEntries: gradeDropdownEntries,
                                initialSelection: _selectedGrade,
                                label: Text('Grade'),
                                onSelected: (int? newValue) {
                                  setState(() {
                                    _selectedGrade =
                                        newValue; // Update the selected grade
                                  });
                                },
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    // Border roundness
                                    borderSide: BorderSide(
                                      color:
                                          Colors.grey.shade300, // Border color
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    // Border roundness
                                    borderSide: BorderSide(
                                      color: Colors
                                          .blue, // Border color when focused
                                      width: 2.0, // Border width when focused
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    // Border roundness
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      // Border color when enabled
                                      width: 1.0, // Border width when enabled
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors
                                        .black, // Label text color and style
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );
                                  if (picked != null && picked != _date) {
                                    setState(() {
                                      _date = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 8, right: 8),
                                  // Padding inside the container
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // Background color
                                    borderRadius: BorderRadius.circular(8),
                                    // Border roundness
                                    border: Border.all(
                                      color:
                                          Colors.grey.shade300, // Border color
                                      width: 1.0, // Border width
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    // Ensures the container is as small as possible
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue, // Icon color
                                        size: 20, // Icon size
                                      ),
                                      SizedBox(width: 8),
                                      // Space between icon and text
                                      Text(
                                        _date == null
                                            ? 'Pick a date'
                                            : DateFormat('yyyy-MM-dd')
                                                .format(_date!),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black, // Text color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _createGrade,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white, // Text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border roundness
                            ),
                            elevation: 0, // Removes shadow
                          ),
                          child: Text('Grade'),
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
