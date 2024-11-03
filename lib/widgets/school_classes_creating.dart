import 'package:flutter/material.dart';

class SchoolClassesCreating extends StatelessWidget {
  final List<TextEditingController> classControllers;
  final VoidCallback onAddClass;
  final Function(int) onDeleteClass;

  const SchoolClassesCreating({
    Key? key,
    required this.classControllers,
    required this.onAddClass,
    required this.onDeleteClass
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          Text('Now let\'s create some classes:'),
          SizedBox(height: 8),
          Column(
            children: [
              for (var i = 0; i < classControllers.length; i++)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: classControllers[i],
                          decoration: InputDecoration(
                            labelText: 'Class ${i + 1}',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => onDeleteClass(i), // Call the delete callback
                      ),
      
                    ],
                  ),
                ),
              if (classControllers.isEmpty || classControllers.length < 10)
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.blue, size: 30),
                  onPressed: onAddClass,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
