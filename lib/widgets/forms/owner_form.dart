import 'package:flutter/material.dart';
import 'package:scientia/views/multi_step_form.dart';
import 'package:scientia/widgets/lesson_spot_widget.dart';
import 'package:scientia/widgets/school_classes_creating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/cloud_functions.dart';
import '../../services/institution_service.dart';
import '../../services/lesson_spot_service.dart';

class OwnerOnboarding extends StatefulWidget {
  final Function(bool) onFormCompleted;
  final AppBar customAppBar;
  const OwnerOnboarding({super.key,
    required this.onFormCompleted,
    required this.customAppBar
    });

  @override
  _OwnerOnboardingState createState() => _OwnerOnboardingState();
}

class _OwnerOnboardingState extends State<OwnerOnboarding> {
  final TextEditingController _schoolNameController = TextEditingController();
  // final List<TextEditingController> _classControllers = [];
  //
  // Map<String, List<Map<String, TimeOfDay>>> lessonsPerDay = {
  //   'SUN': [],
  //   'MON': [],
  //   'TUE': [],
  //   'WED': [],
  //   'THU': [],
  //   'FRI': [],
  //   'SAT': [],
  // };
  // Set<String> enabledDays = {};

  // @override
  // void initState() {
  //   super.initState();
  //   // Pre-select Sunday when the widget is initialized
  //   enabledDays.add('SUN');
  //   // Add a default lesson for Sunday
  //   lessonsPerDay['SUN'] = [
  //     {
  //       'startTime': TimeOfDay(hour: 9, minute: 0),
  //       'endTime': TimeOfDay(hour: 10, minute: 0),
  //     }
  //   ];
  // }

  void dispose() {
    _schoolNameController.dispose();
    super.dispose();
  }


  // Future<void> _nextStep() async {
  //   if (_currentStep < _totalSteps) {
  //     setState(() {
  //       _currentStep++;
  //     });
  //   } else {
  //     widget.onFormCompleted(true);
  //   }
  // }
  //
  // Future<void> _previousStep() async{
  //   if (_currentStep > 0) {
  //     setState(() {
  //       _currentStep--;
  //     });
  //   }
  // }
  //
  // void _deleteClassField(int index) {
  //   setState(() {
  //     if (index >= 0 && index < _classControllers.length) {
  //       _classControllers.removeAt(index);
  //     }
  //   });
  // }
  //
  // void _addNewClassField() {
  //   setState(() {
  //     _classControllers.add(TextEditingController());
  //   });
  // }
  //
  // void _toggleDayEnabled(String dayAbbr, bool isEnabled) {
  //   setState(() {
  //     if (isEnabled) {
  //       enabledDays.add(dayAbbr);
  //     } else {
  //       enabledDays.remove(dayAbbr);
  //     }
  //   });
  // }
  //
  // void _addLesson(String dayAbbr) {
  //   setState(() {
  //     lessonsPerDay[dayAbbr]!.add({
  //       'startTime': TimeOfDay(hour: 9, minute: 0),
  //       'endTime': TimeOfDay(hour: 10, minute: 0),
  //     });
  //   });
  // }
  //
  // void _deleteLesson(String dayAbbr, int index) {
  //   setState(() {
  //     lessonsPerDay[dayAbbr]!.removeAt(index);
  //   });
  // }
  //
  // void _changeLessonTime(String dayAbbr, int index, TimeOfDay newTime, bool isStartTime) {
  //   setState(() {
  //     if (isStartTime) {
  //       lessonsPerDay[dayAbbr]![index]['startTime'] = newTime;
  //     } else {
  //       lessonsPerDay[dayAbbr]![index]['endTime'] = newTime;
  //     }
  //   });
  // }

  // Now the save logic is inside the MultiStepForm
  // Future<void> _saveSchoolAndClasses() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('schoolName', _schoolNameController.text);
  //   List<String> classes = _classControllers.map((controller) => controller.text).toList();
  //   await prefs.setStringList('classNames', classes);
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('School and classes saved successfully!')),
  //   );
  //
  //   _nextStep(); // Go to the next step after saving
  // }
  //
  // Future<void> _saveLessonSpots() async {
  //   try {
  //     LessonSpotService lessonSpotService = LessonSpotService();
  //     await lessonSpotService.saveLessonSpots(lessonsPerDay);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Lesson spots successfully saved.')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error saving lesson spots: $e')),
  //     );
  //   }
  //
  //   _nextStep();
  // }

  // Future<void> _printAndClearSharedPreferences() async {
  //   // Retrieve SharedPreferences instance
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   // Retrieve stored data
  //   String? schoolName = prefs.getString('schoolName');
  //   List<String>? classNames = prefs.getStringList('classNames');
  //
  //   // Print the retrieved data to console
  //   print('School Name: $schoolName');
  //   print('Class Names: ${classNames?.join(', ') ?? 'No classes found'}');
  //
  //   // Clear all data from shared preferences
  //   await prefs.clear();
  //
  //   print('SharedPreferences cleared.');
  //
  //   // Go to the next step or complete the process
  //   _nextStep();
  // }
  

  // Future<void> _buildNextFunction() {
  //   switch (_currentStep) {
  //     case 0:
  //       return _nextStep();
  //     case 1:
  //       return _saveSchoolAndClasses();
  //     case 2:
  //       return _saveLessonSpots();
  //     case 3:
  //       return _printAndClearSharedPreferences();
  //     default:
  //       return _nextStep();
  //   }
  // }

  // String _getText() {
  //   switch (_currentStep) {
  //     case 0:
  //       return 'Welcome';
  //     case 1:
  //       return 'School Info';
  //     case 2:
  //       return 'Preferences';
  //     case 3:
  //       return 'Confirmation';
  //     default:
  //       return 'Setup Wizard';
  //   }
  // }

  // double _calculateProgress() {
  //   return (_currentStep) / (_totalSteps);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.customAppBar,

      body: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 32, left: 32, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Heading
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TextField(
                controller: _schoolNameController,
                decoration: InputDecoration(
                  labelText: 'Name of institution',
                  labelStyle: TextStyle(
                      color: Colors.black, // Change label color to grey
                      fontSize: 16,
                      height: 1
                  ),
                  //enabledBorder: null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1), // Default grey underline
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1), // Underline when focused
                  ),
                  contentPadding: EdgeInsets.zero, // Padding inside the input (no horizontal padding to align with underline)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Coat of arms (optional)",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Spacer(),
                    TextButton(
                      child: Text(
                        'Create',
                        style: TextStyle(
                            fontSize: 12, color: Colors.white, height: 1
                        ),
                      ),
                      onPressed: () {},
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                        overlayColor: WidgetStateProperty.all(Colors.grey.shade800),
                        backgroundColor: WidgetStateProperty.all(Colors.black),
                        // Change background color to grey
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            // Set border radius to 8
                          ),
                        ),
                        alignment: Alignment.center,
                        // Align the content to the center
                        elevation: WidgetStateProperty.all(0.1),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // School Name Input
            Spacer(),
            // Create Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final schoolName = _schoolNameController.text;

                      if (schoolName.isNotEmpty) {
                        // Call the cloud function to create the institution
                        CloudFunctions cloudFunctions = CloudFunctions();
                        await cloudFunctions.createInstitution(schoolName);
                        print("Creating school with name: $schoolName");
                        widget.onFormCompleted(true); // Success
                      } else {
                        print("School name is empty");
                        widget.onFormCompleted(false);
                      }
                    } catch (e) {
                      print("An error occurred: $e");
                      widget.onFormCompleted(false);
                    }
                  },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.grey.shade300),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  // Change background color to grey
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color:
                          Colors.grey.shade300), // Set border radius to 8
                    ),
                  ),
                  alignment: Alignment.center,
                  // Align the content to the center
                  elevation: WidgetStateProperty.all(0.1),
                ),
                child: Text(
                  'Complete',
                  style: TextStyle(
                    color: Colors.black, // Black text for the button
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

