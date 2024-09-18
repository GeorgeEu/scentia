import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../services/cloud_storage.dart';
import '../services/grade_creation_service.dart';
import 'custom_menu.dart';

class StDialog {
  static Future<void> showEventUpdateDialog(
      BuildContext context, {
        required TextEditingController nameController,
        required TextEditingController descController,
        required DateTime currentDate, // Current date as DateTime
        required List<Class> classList,
        required String selectedClassName,
        required String? currentImageUrl, // Pass the current image URL
        required Function(String selectedClassId, String? imageUrl, DateTime? updatedDate) onSave, // Function to save the event
      }) async {
    // Image picker
    final ImagePicker _imagePicker = ImagePicker();
    File? _selectedImage;
    String? _imageUrl = currentImageUrl;

    // Variable to store the selected or updated date
    DateTime? _selectedDate = currentDate;

    // Function to pick an image
    Future<void> _pickImage(StateSetter setState) async {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _selectedImage = File(image.path); // Update the selected image
        setState(() {}); // Trigger rebuild
      }
    }

    // Function to open Date Picker
    Future<void> _pickDate(BuildContext context, StateSetter setState) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate; // Update the selected date
        });
      }
    }

    // Resizing and uploading the image (use your CloudStorage service)
    Future<void> _uploadNewImage() async {
      if (_selectedImage != null) {
        // Resize and upload the new image
        final cloudStorage = CloudStorage();
        _imageUrl = await cloudStorage.uploadResizedImage(_selectedImage!, 0.5);
      }
    }

    TextEditingController classController = TextEditingController(text: selectedClassName);
    String? selectedClassId = classList
        .firstWhere((classItem) => classItem.name == selectedClassName, orElse: () => classList.first)
        .id;

    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside the dialog
      builder: (context) {
        return Dialog.fullscreen(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar-like custom header
                  Container(
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the full-screen dialog
                          },
                        ),
                        Text('Update Event', style: TextStyle(fontSize: 18, height: 1)),
                        Spacer(),
                        TextButton(
                          onPressed: () async {
                            if (selectedClassId != null) {
                              await _uploadNewImage(); // Upload image if selected
                              onSave(selectedClassId!, _imageUrl, _selectedDate); // Pass new or existing image URL and updated date
                              Navigator.of(context).pop(); // Close the dialog
                            }
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Picker Section
                          ListTile(
                            title: Text(_selectedDate == null
                                ? 'Select Date'
                                : 'Date: ${DateFormat('MMM d, yyyy').format(_selectedDate!)}'),
                            trailing: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.zero,
                            onTap: () => _pickDate(context, setState), // Open Date Picker
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(labelText: 'Event Name'),
                            ),
                          ),
                          // Class Dropdown
                          Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: CustomDropdownMenu<Class>(
                              widthWidget: MediaQuery.of(context).size.width,
                              horizontalPadding: 16,
                              title: 'Class',
                              label: Text('Select Class'),
                              controller: classController,
                              items: classList,
                              selectedItem: classList.firstWhere((classItem) => classItem.name == selectedClassName),
                              itemTitleBuilder: (classItem) => classItem.name,
                              onSelected: (Class selected) {
                                selectedClassId = selected.id;
                                classController.text = selected.name;
                              },
                            ),
                          ),
                          // Row for Current and New Image
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              children: [
                                // Current Image
                                if (currentImageUrl != null)
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              currentImageUrl,
                                              width: double.infinity,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        // Overlay Icon on Current Image
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.image_outlined,
                                              color: Colors.white.withOpacity(0.9),
                                              size: 36,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(width: 8),
                                // New Image Selection
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await _pickImage(setState);
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: _selectedImage == null
                                              ? Icon(Icons.image, size: 36, color: Colors.grey[600])
                                              : ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Event Description
                          TextField(
                            controller: descController,
                            maxLines: 5,
                            decoration: InputDecoration(labelText: 'Description'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  static Future<void> showHomeworkUpdateDialog(
      BuildContext context, {
        required TextEditingController taskController,
        required DateTime currentDate, // Current date as DateTime
        required List<Class> classList, // List of classes
        required List<Subject> subjectList, // List of subjects
        required String selectedClassName, // Currently selected class name
        required String selectedSubjectName, // Currently selected subject name
        required Function(String selectedClassId, String selectedSubjectId, DateTime? updatedDate) onHwSave, // Function to save the event
      }) async {
    DateTime? _selectedDate = currentDate;

    // Function to pick a new date
    Future<void> _pickDate(BuildContext context, StateSetter setState) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate; // Update the selected date
        });
      }
    }

    TextEditingController classController =
    TextEditingController(text: selectedClassName);
    String? selectedClassId = classList
        .firstWhere((classItem) => classItem.name == selectedClassName,
        orElse: () => classList.first)
        .id;

    TextEditingController subjectController =
    TextEditingController(text: selectedSubjectName);
    String? selectedSubjectId = subjectList
        .firstWhere((subjectItem) => subjectItem.name == selectedSubjectName,
        orElse: () => subjectList.first)
        .id;

    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return Dialog.fullscreen(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar-like custom header
                  Container(
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        Text('Update Homework',
                            style: TextStyle(fontSize: 18, height: 1)),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            // Pass the selected values to onSave when the user clicks save
                            onHwSave(selectedClassId!, selectedSubjectId!,
                                _selectedDate);
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(_selectedDate == null
                                ? 'Select Date'
                                : 'Date: ${DateFormat('MMM d, yyyy').format(_selectedDate!)}'),
                            trailing: Icon(Icons.calendar_today),
                            contentPadding: EdgeInsets.zero,
                            onTap: () => _pickDate(context, setState), // Open Date Picker
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: CustomDropdownMenu<Subject>(
                              widthWidget: MediaQuery.of(context).size.width,
                              horizontalPadding: 16,
                              title: 'Subject',
                              label: Text('Select Subject'),
                              controller: subjectController,
                              items: subjectList,
                              selectedItem: subjectList.firstWhere(
                                      (subjectItem) =>
                                  subjectItem.name == selectedSubjectName),
                              itemTitleBuilder: (subjectItem) => subjectItem.name,
                              onSelected: (Subject selected) {
                                selectedSubjectId = selected.id;
                                subjectController.text = selected.name;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: CustomDropdownMenu<Class>(
                              widthWidget: MediaQuery.of(context).size.width,
                              horizontalPadding: 16,
                              title: 'Class',
                              label: Text('Select Class'),
                              controller: classController,
                              items: classList,
                              selectedItem: classList.firstWhere((classItem) =>
                              classItem.name == selectedClassName),
                              itemTitleBuilder: (classItem) => classItem.name,
                              onSelected: (Class selected) {
                                selectedClassId = selected.id;
                                classController.text = selected.name;
                              },
                            ),
                          ),
                          // Subject Dropdown
                          Padding(
                            padding: const EdgeInsets.only(bottom: 22),
                            child: TextField(
                              controller: taskController,
                              maxLines: 5,
                              decoration: InputDecoration(labelText: 'Task'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  static Future<void> showGradeUpdateDialog(
      BuildContext context, {
        required TextEditingController gradeController,
        required DateTime currentDate, // Current date as DateTime
        required List<Student> studentList, // List of students
        required List<Subject> subjectList, // List of subjects
        required String selectedStudentName, // Currently selected student name
        required String selectedSubjectName, // Currently selected subject name
        required Function(String selectedStudentId, String selectedSubjectId, int? selectedGrade, DateTime? updatedDate) onSave, // Function to save the event
      }) async {
    DateTime? _selectedDate = currentDate;
    int? _selectedGrade;

    // Function to pick a new date
    Future<void> _pickDate(BuildContext context, StateSetter setState) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate; // Update the selected date
        });
      }
    }

    TextEditingController studentController =
    TextEditingController(text: selectedStudentName);
    String? selectedStudentId = studentList
        .firstWhere((studentItem) => studentItem.name == selectedStudentName,
        orElse: () => studentList.first)
        .id;

    TextEditingController subjectController =
    TextEditingController(text: selectedSubjectName);
    String? selectedSubjectId = subjectList
        .firstWhere((subjectItem) => subjectItem.name == selectedSubjectName,
        orElse: () => subjectList.first)
        .id;

    // Dropdown entries for grades
    final List<DropdownMenuEntry<int>> gradeDropdownEntries = List.generate(
      6,
          (index) => DropdownMenuEntry(
        value: 5 + index, // Grade values from 5 to 10
        label: (5 + index).toString(), // Display the grade as text
      ),
    );

    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return Dialog(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensures the dialog is only as big as needed
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(_selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${DateFormat('MMM d, yyyy').format(_selectedDate!)}'),
                      trailing: Icon(Icons.calendar_today),
                      contentPadding: EdgeInsets.zero,
                      onTap: () => _pickDate(context, setState), // Open Date Picker
                    ),
                    // Student Dropdown
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: CustomDropdownMenu<Student>(
                        widthWidget: MediaQuery.of(context).size.width,
                        horizontalPadding: 16,
                        title: 'Student',
                        label: Text('Select Student'),
                        controller: studentController,
                        items: studentList,
                        selectedItem: studentList.firstWhere(
                                (studentItem) => studentItem.name == selectedStudentName),
                        itemTitleBuilder: (studentItem) => studentItem.name,
                        onSelected: (Student selected) {
                          selectedStudentId = selected.id;
                          studentController.text = selected.name;
                        },
                      ),
                    ),
                    // Subject Dropdown
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: CustomDropdownMenu<Subject>(
                        widthWidget: MediaQuery.of(context).size.width,
                        horizontalPadding: 16,
                        title: 'Subject',
                        label: Text('Select Subject'),
                        controller: subjectController,
                        items: subjectList,
                        selectedItem: subjectList.firstWhere(
                                (subjectItem) => subjectItem.name == selectedSubjectName),
                        itemTitleBuilder: (subjectItem) => subjectItem.name,
                        onSelected: (Subject selected) {
                          selectedSubjectId = selected.id;
                          subjectController.text = selected.name;
                        },
                      ),
                    ),
                    // Grade Dropdown
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                      child: DropdownMenu<int>(
                        controller: gradeController,
                        dropdownMenuEntries: gradeDropdownEntries,
                        initialSelection: _selectedGrade,
                        label: Text('Grade'),
                        onSelected: (int? newValue) {
                          setState(() {
                            _selectedGrade = newValue; // Update the selected grade
                          });
                        },
                      ),
                    ),
                    // Save and Cancel Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Pass the selected values to onSave when the user clicks save
                            onSave(
                                selectedStudentId!,
                                selectedSubjectId!,
                                _selectedGrade,
                                _selectedDate);
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
