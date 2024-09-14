import 'package:flutter/material.dart';
import '../services/grade_creation_service.dart';
import 'custom_menu.dart';

class StDialog {
  static Future<void> showEventUpdateDialog(
      BuildContext context, {
        required TextEditingController nameController,
        required TextEditingController descController,
        required List<Class> classList, // Pass the list of classes
        required String selectedClassName, // Pass the selected class name as a string
        required Function(String selectedClassId) onSave, // Return the selected class ID on save
      }) async {
    // Create a TextEditingController for the dropdown menu, initialized with the selected class name
    TextEditingController classController = TextEditingController(text: selectedClassName);
    String? selectedClassId = classList.firstWhere((classItem) => classItem.name == selectedClassName, orElse: () => classList.first).id;
    double width = MediaQuery.of(context).size.width * 0.5; // 80% of the screen width
    double height = MediaQuery.of(context).size.height * 0.7; // 60% of the screen height
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: width, // Set the width of the dialog
            height: height, // Set the height of the dialog
            padding: const EdgeInsets.all(16), // Padding inside the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name TextField
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Event Name'),
                  ),
                ),
                // Custom Dropdown for Class selection using the name
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: CustomDropdownMenu<Class>(
                    widthWidget: MediaQuery.of(context).size.width,
                    horizontalPadding: 56,
                    title: 'Class',
                    label: Text('Select Class'),
                    controller: classController, // Bind to the TextEditingController
                    items: classList, // Provide the list of classes
                    selectedItem: classList.firstWhere((classItem) => classItem.name == selectedClassName),
                    itemTitleBuilder: (classItem) => classItem.name, // Show class names in the dropdown
                    onSelected: (Class selected) {
                      selectedClassId = selected.id; // Update the selected class ID
                      classController.text = selected.name; // Update the TextEditingController
                    },
                  ),
                ),
                // Description TextField
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                // Save and Cancel Buttons
                Spacer(),
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
                        if (selectedClassId != null) {
                          onSave(selectedClassId!); // Pass the selected class ID to the save function
                          Navigator.of(context).pop(); // Close the dialog
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
