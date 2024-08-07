import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

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
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),
        ),
        // titleSpacing: 0,
      ),
    );
  }
}
