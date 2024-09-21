import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/widgets/st_dialog.dart';

import '../services/grade_creation_service.dart';
import '../services/update_services.dart';
import '../utils/accounting.dart';

class SearchDelegator extends SearchDelegate {
  final List<Map<String, dynamic>> history;
  final List<Class> classes;
  final List<Subject> subjects;
  final List<Student> students;

  SearchDelegator({
    required this.history,
    required this.classes,
    required this.subjects,
    required this.students,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  TextStyle get searchFieldStyle => TextStyle(
    fontSize: 16, // Smaller font size for the search input text
  );

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // If query is empty, show nothing
    if (query.isEmpty) {
      return Center(
        child: Text("Start typing to search..."),
      );
    }

    final results = history.where((item) {
      return containsSearchQuery(item, query);
    }).toList();

    return buildHistoryResults(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // If query is empty, show nothing
    if (query.isEmpty) {
      return Center(
        child: Text("Start typing to search..."),
      );
    }

    final suggestions = history.where((item) {
      return containsSearchQuery(item, query);
    }).toList();

    return buildHistoryResults(context, suggestions);
  }


  bool containsSearchQuery(Map<String, dynamic> item, String query) {
    final lowerQuery = query.toLowerCase();
    return (item['name']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
        (item['subject']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
        (item['class']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
        (item['user']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
        (item['desc']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
        (item['task']?.toString().toLowerCase().contains(lowerQuery) ?? false) ||
        (item['grade']?.toString().toLowerCase().contains(lowerQuery) ?? false);
  }

  Widget buildHistoryResults(BuildContext context, List<Map<String, dynamic>> results) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: results.length,
        separatorBuilder: (context, index) => Divider(
          thickness: 0.5,
          height: 26,
          indent: 96,
        ),
        itemBuilder: (context, index) {
          final item = results[index];
          final type = item['type'];

          DateTime date = (item['date'] as Timestamp).toDate();
          DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(item['createdAt'] as int);

          switch (type) {
            case 'event':
              return buildEventRow(context, item, date, createdAt);
            case 'grade':
              return buildGradeRow(context, item, date, createdAt);
            case 'homework':
              return buildHomeworkRow(context, item, date, createdAt);
            default:
              return Container();
          }
        },
      ),
    );
  }


  Widget buildEventRow(BuildContext context, Map<String, dynamic> item, DateTime date, DateTime createdAt) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item['imageUrl'] != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Image not available');
                  },
                ),
              ),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'] ?? 'Event',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.1),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'To: ${item['class']}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                'Created: ${DateFormat('MMM d, yyyy').format(createdAt)}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                item['desc'],
                style: TextStyle(fontSize: 14, height: 1.1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(DateFormat('MMM d').format(date), style: TextStyle(fontSize: 12, color: Colors.grey)),
            IconButton(
              icon: Icon(Icons.info_outline_rounded,
                  size: 24,
                  color: Colors.black), // Edit button icon
              padding: EdgeInsets.zero, // Zero padding
              onPressed: () async {
                List<Class> classList = classes;

                DateTime currentDate =
                (item['date'] as Timestamp)
                    .toDate(); // Get the current date
                TextEditingController nameController =
                TextEditingController(text: item['name']);
                String selectedClassName = item['class'];
                String? currentImageUrl = item['imageUrl'];
                TextEditingController descController =
                TextEditingController(text: item['desc']);

                // Show the update dialog
                StDialog.showEventUpdateDialog(
                  context,
                  nameController: nameController,
                  descController: descController,
                  currentDate: currentDate,
                  // Pass the current date
                  classList: classList,
                  // Pass the list of classes
                  selectedClassName: selectedClassName,
                  // Pass the currently selected class name
                  currentImageUrl: currentImageUrl,
                  // Pass the current image URL
                  onSave: (String selectedClassId,
                      String? imageUrl,
                      DateTime? updatedDate) async {
                    final updateService = UpdateServices();

                    try {
                      // Convert updatedDate or currentDate to Timestamp before saving
                      await updateService.updateEvent(
                        item[
                        'id'], // Document ID for the event
                        nameController.text, // Updated name
                        selectedClassId, // Updated class ID
                        descController.text,
                        // Updated description
                        imageUrl,
                        // Use the new image URL if available, or the current one
                        Timestamp.fromDate(updatedDate ??
                            currentDate), // Convert DateTime to Timestamp
                      );
                      await Accounting.detectAndStoreOperation(
                          DatabaseOperation.dbWrite, 1);
                      print('Event updated successfully');
                    } catch (e) {
                      print('Error updating event: $e');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGradeRow(BuildContext context, Map<String, dynamic> item, DateTime date, DateTime createdAt) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                item['grade'].toString(),
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['subject'] ?? 'No subject',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'To: ${item['user'] ?? 'No user'}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                'Created: ${DateFormat('MMM d, yyyy').format(createdAt)}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(DateFormat('MMM d').format(date), style: TextStyle(fontSize: 12, color: Colors.grey)),
            IconButton(
              icon: Icon(Icons.info_outline_rounded,
                  size: 24, color: Colors.black),
              padding: EdgeInsets.zero, // Zero padding
              onPressed: () async {
                List<Student> studentList =
                    students; // Assuming students is the list of users
                List<Subject> subjectList =
                    subjects; // Assuming subjects is the list of subjects

                DateTime currentDate =
                (item['date'] as Timestamp)
                    .toDate(); // Get the current date
                TextEditingController gradeController =
                TextEditingController(
                    text: item['grade'].toString());
                String selectedStudentName =
                item['user']; // Fetch the user
                String selectedSubjectName =
                item['subject']; // Fetch the subject

                // Show the update dialog for grade
                StDialog.showGradeUpdateDialog(
                  context,
                  gradeController: gradeController,
                  currentDate: currentDate,
                  // Pass the current date
                  studentList: studentList,
                  // Pass the list of students
                  subjectList: subjectList,
                  // Pass the list of subjects
                  selectedStudentName: selectedStudentName,
                  // Pass the currently selected user name
                  selectedSubjectName: selectedSubjectName,
                  // Pass the currently selected subject name
                  onSave: (String selectedStudentId,
                      String selectedSubjectId,
                      int? selectedGrade,
                      DateTime? updatedDate) async {
                    final updateService = UpdateServices();

                    try {
                      // Convert updatedDate or currentDate to Timestamp before saving
                      await updateService.updateGrade(
                        item[
                        'id'], // Document ID for the grade
                        selectedStudentId, // Updated student ID
                        selectedSubjectId, // Updated subject ID
                        selectedGrade ??
                            int.parse(
                                item['grade'].toString()),
                        // Updated grade as int
                        Timestamp.fromDate(updatedDate ??
                            currentDate), // Convert DateTime to Timestamp
                      );
                      await Accounting.detectAndStoreOperation(
                          DatabaseOperation.dbWrite, 1);

                      print('Grade updated successfully');
                    } catch (e) {
                      print('Error updating grade: $e');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildHomeworkRow(BuildContext context, Map<String, dynamic> item, DateTime date, DateTime createdAt) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'HW',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['subject'] ?? 'No subject',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'To: ${item['class'] ?? 'No class'}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                'Created: ${DateFormat('MMM d, yyyy').format(createdAt)}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                item['task'] ?? 'No task',
                style: TextStyle(fontSize: 14, height: 1.1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(DateFormat('MMM d').format(date), style: TextStyle(fontSize: 12, color: Colors.grey)),
            IconButton(
              icon: Icon(Icons.info_outline_rounded,
                  size: 24, color: Colors.black),
              padding: EdgeInsets.zero, // Zero padding
              onPressed: () async {
                List<Class> classList = classes;
                List<Subject> subjectList = subjects;

                DateTime currentDate =
                (item['date'] as Timestamp)
                    .toDate(); // Get the current date
                TextEditingController taskController =
                TextEditingController(text: item['task']);
                String selectedClassName = item['class'];
                String selectedSubjectName = item['subject'];

                // Show the update dialog for homework
                StDialog.showHomeworkUpdateDialog(
                  context,
                  taskController: taskController,
                  currentDate: currentDate,
                  // Pass the current date
                  classList: classList,
                  // Pass the list of classes
                  subjectList: subjectList,
                  // Pass the list of subjects
                  selectedClassName: selectedClassName,
                  // Pass the currently selected class name
                  selectedSubjectName: selectedSubjectName,
                  // Pass the currently selected subject name
                  onHwSave: (String selectedClassId,
                      String selectedSubjectId,
                      DateTime? updatedDate) async {
                    final updateService = UpdateServices();

                    try {
                      // Convert updatedDate or currentDate to Timestamp before saving
                      await updateService.updateHomework(
                          item['id'],
                          // Document ID for the homework
                          selectedSubjectId,
                          selectedClassId,
                          taskController.text,
                          Timestamp.fromDate(updatedDate ??
                              currentDate) // Date
                      );
                      await Accounting.detectAndStoreOperation(
                          DatabaseOperation.dbWrite, 1);

                      print('Homework updated successfully');
                    } catch (e) {
                      print('Error updating homework: $e');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
