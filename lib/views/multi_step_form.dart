import 'package:flutter/material.dart';
import 'package:scientia/views/lesson_spot_widget.dart';
import 'package:scientia/widgets/school_classes_creating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page.dart'; // Make sure to import your main page

class MultiStepForm extends StatefulWidget {
  final Function(bool) onFormCompleted;

  const MultiStepForm({super.key, required this.onFormCompleted});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  int _currentStep = 0;
  final int _totalSteps = 3;
  final TextEditingController _schoolNameController = TextEditingController();
  final List<TextEditingController> _classControllers = [];

  @override
  void dispose() {
    _schoolNameController.dispose();
    for (var controller in _classControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      widget.onFormCompleted(true);
    }
  }

  Future<void> _previousStep() async{
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _deleteClassField(int index) {
    setState(() {
      if (index >= 0 && index < _classControllers.length) {
        _classControllers.removeAt(index);
      }
    });
  }

  void _addNewClassField() {
    setState(() {
      _classControllers.add(TextEditingController());
    });
  }

  // Now the save logic is inside the MultiStepForm
  Future<void> _saveSchoolAndClasses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('schoolName', _schoolNameController.text);
    List<String> classes = _classControllers.map((controller) => controller.text).toList();
    await prefs.setStringList('classNames', classes);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('School and classes saved successfully!')),
    );

    _nextStep(); // Go to the next step after saving
  }

  Future<void> _printAndClearSharedPreferences() async {
    // Retrieve SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Retrieve stored data
    String? schoolName = prefs.getString('schoolName');
    List<String>? classNames = prefs.getStringList('classNames');

    // Print the retrieved data to console
    print('School Name: $schoolName');
    print('Class Names: ${classNames?.join(', ') ?? 'No classes found'}');

    // Clear all data from shared preferences
    await prefs.clear();

    print('SharedPreferences cleared.');

    // Go to the next step or complete the process
    _nextStep();
  }


  Future<void> _buildNextFunction() {
    switch (_currentStep) {
      case 0:
        return _nextStep();
      case 1:
        return _saveSchoolAndClasses();
      case 2:
        return _nextStep();
      case 3:
        return _printAndClearSharedPreferences();
      default:
        return _nextStep();
    }
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return Center(child: Text('bla-bla'));
      case 1:
        return SchoolClassesCreating(
          schoolNameController: _schoolNameController,
          classControllers: _classControllers,
          onDeleteClass: _deleteClassField,
          onAddClass: _addNewClassField,
        );
      case 2:
        return Center(child: Text('bla-bla'));
      case 3:
        return Center(child: Text('bla-bla'));
    // Continue for other steps...
      default:
        return Container();
    }
  }

  String _getText() {
    switch (_currentStep) {
      case 0:
        return 'Welcome';
      case 1:
        return 'School Info';
      case 2:
        return 'Preferences';
      case 3:
        return 'Confirmation';
      default:
        return 'Setup Wizard';
    }
  }

  double _calculateProgress() {
    return (_currentStep) / (_totalSteps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getText()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: LinearProgressIndicator(
              value: _calculateProgress(),
              minHeight: 4,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey[300],
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: _buildContent()
              )
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_currentStep > 0 && _currentStep < _totalSteps + 1)
                  TextButton(
                    onPressed: _previousStep,
                    child: Text('Previous'),
                  ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _buildNextFunction,
                  child: Text(_currentStep < _totalSteps ? 'Next' : 'OK'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

