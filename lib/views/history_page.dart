import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/widgets/empty_state_page.dart';

import '../services/grade_creation_service.dart';
import '../services/update_services.dart';
import '../widgets/st_dialog.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final List<Class> classes;
  final List<Subject> subjects;
  final List<Student> students;

  const HistoryPage(
      {super.key,
      required this.students,
      required this.classes,
      required this.history,
      required this.subjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffefeff4),
      appBar: AppBar(
        backgroundColor: Color(0xFFA4A4FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              // showSearch(context: context, delegate: );
            },
          )
        ],
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        // titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 32),
        child: history.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                // Prevent scrolling inside the ListView
                itemCount: history.length,
                // Limit to 4 items
                separatorBuilder: (context, index) => Divider(
                  thickness: 0.5,
                  height: 26,
                  indent: 96,
                ),
                itemBuilder: (context, index) {
                  final item = history[index];
                  final type = item['type'];

                  DateTime date = (item['date'] as Timestamp).toDate();
                  DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(
                      item['createdAt'] as int);
                  // Switch logic to display appropriate content based on type
                  switch (type) {
                    case 'event':
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
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Text(
                                          'Image not available');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['name'] ?? 'Event',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              height: 1.1),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'To: ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              height: 1,
                                              color: Colors
                                                  .grey), // Style for "To"
                                        ),
                                        TextSpan(
                                          text: item['class'],
                                          // Class value in normal color
                                          style: TextStyle(
                                              fontSize: 14,
                                              height: 1,
                                              color: Colors
                                                  .black), // Normal color
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'Created: ', // "Created" in grey
                                          style: TextStyle(
                                              fontSize: 14,
                                              height: 1,
                                              color: Colors.grey),
                                        ),
                                        TextSpan(
                                          text: DateFormat('MMM d, yyyy')
                                              .format(createdAt),
                                          // Rest of the text in normal color
                                          style: TextStyle(
                                              fontSize: 14,
                                              height: 1,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Text(
                                    item['desc'],
                                    style:
                                        TextStyle(fontSize: 14, height: 1.1),
                                    maxLines: 1, // Limit to 1 line
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 14, left: 14, top: 4, bottom: 10),
                                child: Text(
                                  DateFormat('MMM d').format(date),
                                  // Format the date
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      height: 1),
                                ),
                              ),
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
                                      TextEditingController(
                                          text: item['name']);
                                  String selectedClassName = item['class'];
                                  String? currentImageUrl = item['imageUrl'];
                                  TextEditingController descController =
                                      TextEditingController(
                                          text: item['desc']);

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
                    case 'grade':
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Grade Display Box
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
                                // Display the grade inside the container
                                child: Text(
                                  item['grade']
                                      .toString(), // Display the grade
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Grade Details Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['subject'] ?? 'No subject',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Prevent overflow
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'To: ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              height: 1,
                                              color: Colors
                                                  .grey), // Style for "To"
                                        ),
                                        TextSpan(
                                          text: item['user'] ?? 'No user',
                                          // User value
                                          style: TextStyle(
                                              fontSize: 14,
                                              height: 1,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'Created: ', // "Created" in grey
                                          style: TextStyle(
                                              fontSize: 14,
                                              height: 1,
                                              color: Colors.grey),
                                        ),
                                        TextSpan(
                                          text: DateFormat('MMM d, yyyy')
                                              .format(createdAt),
                                          // Format the createdAt date
                                          style: TextStyle(
                                              fontSize: 14,
                                              height: 1,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Column for date and icon button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 14, left: 14, top: 4, bottom: 10),
                                child: Text(
                                  DateFormat('MMM d').format(date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                                ),
                              ),
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
                                        ;

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
                    case 'homework':
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Homework Icon (similar to event image)
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
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Homework Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['subject'] ?? 'No subject',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Prevent overflow
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'To: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item['class'] ?? 'No class',
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Created: ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: DateFormat('MMM d, yyyy')
                                              .format(createdAt),
                                          style: TextStyle(
                                            fontSize: 14,
                                            height: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Text(
                                    item['task'] ?? 'No task',
                                    style:
                                        TextStyle(fontSize: 14, height: 1.1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Column with date and icon button (similar to event structure)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 14, left: 14, top: 4, bottom: 10),
                                child: Text(
                                  DateFormat('MMM d').format(date),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    height: 1,
                                  ),
                                ),
                              ),
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
                                      TextEditingController(
                                          text: item['task']);
                                  String selectedClassName = item['class'];
                                  String selectedSubjectName =
                                      item['subject'];

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

                                        print(
                                            'Homework updated successfully');
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
                    default:
                      return Container();
                  }
                },
              )
            : Center(
                child: EmptyStatePage(
                  message: 'There is no homework',
                ),
              ),
      ),
    );
  }
}
