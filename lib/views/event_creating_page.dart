import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/cloud_storage.dart';
import '../services/grade_creation_service.dart';
import '../utils/accounting.dart';
import '../widgets/custom_menu.dart';
import '../widgets/empty_state_page.dart';
import '../widgets/st_form_textfield.dart';
import '../widgets/st_snackbar.dart';

class EventCreatingPage extends StatefulWidget {
  final List<Class> classes;
  final String teacherName;

  EventCreatingPage({
    super.key,
    required this.classes,
    required this.teacherName,
  });

  @override
  State<EventCreatingPage> createState() => _EventCreatingPageState();
}

class _EventCreatingPageState extends State<EventCreatingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  DateTime? _date;
  String? _selectedClass;
  String? _teacherName;
  File? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _imagePicker = ImagePicker();

  final CloudStorage _cloudStorageService =
      CloudStorage(); // Create an instance of CloudStorageService

  @override
  void initState() {
    super.initState();
    _teacherName = widget.teacherName;
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Method to create the event and upload the thumbnail if present
  void _createEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isUploading = true; // Show the loading indicator
        });

        String? imageUrl;

        // If an image is selected, upload the thumbnail using CloudStorageService
        if (_selectedImage != null) {
          // Upload the resized image (e.g., resize to 50%)
          imageUrl = await _cloudStorageService.uploadResizedImage(
              _selectedImage!, 0.5);
          if (imageUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              StSnackBar(message: 'Failed to upload image'),
            );
            return;
          }
        }

        // Build the event data with the image URL
        final eventCollection = FirebaseFirestore.instance.collection('events');
        final newEvent = {
          'class': FirebaseFirestore.instance.doc(_selectedClass!),
          'date': Timestamp.fromDate(_date!),
          'name': _nameController.text,
          'desc': _descController.text,
          'organizer': _teacherName,
          'imageUrl': imageUrl, // Add the image URL to the event data
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        };

        await eventCollection.add(newEvent);

        // Success message
        ScaffoldMessenger.of(context)
            .showSnackBar(StSnackBar(message: 'Event created successfully'));
        Navigator.pop(context); // Close the form
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          StSnackBar(message: 'Failed to create event: $error'),
        );
      } finally {
        setState(() {
          _isUploading = false; // Hide the loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F8),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFFA4A4FF),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text(
          'New Event',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: widget.classes.isEmpty
          ? const Center(
              child: EmptyStatePage(
                message: 'There are no classes available',
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
                          widthWidget: MediaQuery.of(context).size.width,
                          horizontalPadding: 16,
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
                      StFormTextfield(
                        controller: _nameController,
                        labelText: 'Name',
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
                      ),
                      // New widget for selecting an image from gallery
                      ListTile(
                        title: Text(_selectedImage == null
                            ? 'Select Image'
                            : 'Image Selected'),
                        trailing: const Icon(Icons.image),
                        onTap: _pickImage, // Trigger image picker
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: StFormTextfield(
                          controller: _descController,
                          labelText: 'Description',
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the description';
                            }
                            return null;
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(_date == null ? 'Date' : _date.toString()),
                        trailing: const Icon(Icons.calendar_today),
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
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _createEvent,
                          // Disable button during upload
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _isUploading
                              ? Center(
                                child: const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : const Text('Create Event'),
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
