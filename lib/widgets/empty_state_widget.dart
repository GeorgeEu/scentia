import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String path;
  final String message;
  final double size;
  const EmptyStateWidget({required this.message, required this.path, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          path,
          //'assets/birds.png',
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Text('Image not available'); // Error text if image fails to load
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800
            ),
          ),
        ),
      ],
    );
  }
}
