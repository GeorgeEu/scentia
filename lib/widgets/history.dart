import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scientia/services/update_services.dart';
import 'package:scientia/views/history_page.dart';
import 'package:scientia/widgets/st_chevron_right.dart';
import 'package:scientia/widgets/st_dialog.dart';
import 'package:scientia/widgets/st_header.dart';
import 'package:scientia/widgets/st_row.dart';
import 'package:scientia/widgets/empty_state_widget.dart';

import '../services/grade_creation_service.dart';

class History extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final List<Class> classes;

  const History({super.key, required this.history, required this.classes});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom StRow widget with header and chevron for navigation
        StRow(
          stHeader: StHeader(text: 'History'),
          stChevronRight: StChevronRight(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
          ),
          onPress: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HistoryPage()),
            );
          },
        ),

        // Padding for the history container
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
            child: history.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // Prevent scrolling inside the ListView
                    itemCount: history.length > 4 ? 4 : history.length,
                    // Limit to 4 items
                    separatorBuilder: (context, index) => Divider(
                      thickness: 0.5,
                      height: 24,
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
                                  padding: const EdgeInsets.only(right: 14),
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
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.grey), // Style for "To"
                                            ),
                                            TextSpan(
                                              text: item['class'], // Class value in normal color
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.black), // Normal color
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
                                              text: 'Created: ', // "Created" in grey
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.grey),
                                            ),
                                            TextSpan(
                                              text: DateFormat('MMM d, yyyy').format(createdAt), // Rest of the text in normal color
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.black),
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
                                    padding: const EdgeInsets.only(right: 14, left: 14, top: 4, bottom: 10),
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
                                    icon: Icon(Icons.more_horiz_outlined, size: 24, color: Colors.black,), // Edit button icon
                                    padding: EdgeInsets.zero, // Zero padding
                                    onPressed: () async {
                                      List<Class> classList = classes;
                                      // Initialize the controllers with the current event data
                                      TextEditingController nameController = TextEditingController(text: item['name']);
                                      String selectedClassName = item['class'];
                                      TextEditingController descController = TextEditingController(text: item['desc']);

                                      // Show the update dialog
                                      StDialog.showEventUpdateDialog(
                                        context,
                                        nameController: nameController, // Pass the initialized controller
                                        classList: classList,
                                        descController: descController,
                                        selectedClassName: selectedClassName,
                                        onSave: (String selectedClassId) async {
                                          final updateService = UpdateServices(); // Ensure you have the correct service
                                          try {
                                            // Use the values from the controllers to update Firestore
                                            await updateService.updateEvent(
                                              item['id'], // Document ID for the event
                                              nameController.text, // Updated name from the controller
                                              selectedClassId, // Updated class from the controller
                                              descController.text, // Updated description from the controller
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: SizedBox(
                                        width: double.infinity,
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
                                                    height: 1),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              child: Text(
                                                DateFormat('MMM d').format(date),
                                                // Format the date
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    height: 1),
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
                                              text: 'To: ',
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.grey), // Style for "To"
                                            ),
                                            TextSpan(
                                              text: item['user'], // Class value in normal color
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.black), // Normal color
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
                                              text: 'Created: ', // "Created" in grey
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.grey),
                                            ),
                                            TextSpan(
                                              text: DateFormat('MMM d, yyyy').format(createdAt), // Rest of the text in normal color
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        case 'homework':
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
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                      child: SizedBox(
                                        width: double.infinity,
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
                                                    height: 1),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 14),
                                              child: Text(
                                                DateFormat('MMM d').format(date),
                                                // Format the date
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    height: 1),
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
                                              text: 'To: ',
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.grey), // Style for "To"
                                            ),
                                            TextSpan(
                                              text: item['class'], // Class value in normal color
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.black), // Normal color
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
                                              text: 'Created: ', // "Created" in grey
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.grey),
                                            ),
                                            TextSpan(
                                              text: DateFormat('MMM d, yyyy').format(createdAt), // Rest of the text in normal color
                                              style: TextStyle(fontSize: 14, height: 1, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 14),
                                      child: Text(
                                        item['task'],
                                        style:
                                            TextStyle(fontSize: 14, height: 1.1),
                                        maxLines: 1, // Limit to 1 line
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        default:
                          return Container();
                      }
                    },
                  )
                : SizedBox(
                    height: 186,
                    width: double.infinity,
                    child: EmptyStateWidget(
                      path: 'assets/platopys.png',
                      size: 130,
                      message: 'There is no history yet',
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
