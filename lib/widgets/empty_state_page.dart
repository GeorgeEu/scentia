import 'package:flutter/material.dart';

class EmptyStatePage extends StatelessWidget {
  final String message;

  const EmptyStatePage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/puppies.png',
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Text('Image not available'); // Error text if image fails to load
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade800
            ),
          ),
        ),
      ],
    );
  }
}
