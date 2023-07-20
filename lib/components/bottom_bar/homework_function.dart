import 'package:card_test/components/bottom_bar/homework_text_field.dart';
import 'package:flutter/material.dart';

void showHomeworkBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 8),
                child: Row(
                  children: [
                    Text(
                      'Create',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              HomeworkTextField(),
              ListTile(
                leading: Icon(Icons.backpack_rounded),
                title: Text('Create a homework'),
                onTap: () {},
              ),
            ],
          ),
        );
      });
}