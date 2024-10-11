import 'package:flutter/material.dart';
import '../widgets/forms/owner_form.dart';
import '../widgets/user_status_widget.dart';
class MultiStepForm extends StatefulWidget {
  final Function(bool) onFormCompleted;

  const MultiStepForm({super.key, required this.onFormCompleted});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  String userStatus = '';

  void _onStatusSelected(String status) {
    setState(() {
      userStatus = status;
    });
  }


  Widget _buildContentForStatus() {
    switch (userStatus) {
      case 'student':
        return Container(); // Show student form
      case 'teacher':
        return Container(); // Show teacher form
      case 'owner':
        return OwnerOnboarding(
          onFormCompleted: widget.onFormCompleted,
          customAppBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {
                setState(() {
                  userStatus = '';
                });
              },
              padding: EdgeInsets.zero,
            ),
            titleSpacing: 0,
            title: Text(
              'Details',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
        ); // Show owner form
      default:
        return UserStatusWidget(onStatusSelected: _onStatusSelected); // Show status selection if none is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentForStatus();
  }
}

