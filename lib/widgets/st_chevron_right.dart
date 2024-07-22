import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StChevronRight extends StatelessWidget {
  final VoidCallback onPressed;

  const StChevronRight({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.only(right: 18.0),
        child: SvgPicture.asset(
          width: 14,
          height: 14,
          'assets/chevron-right.svg', // Path to your SVG file
        ),
      ),
    );
  }
}
