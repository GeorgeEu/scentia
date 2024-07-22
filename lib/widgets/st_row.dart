import 'package:flutter/material.dart';

class StRow extends StatelessWidget {
  final Widget stHeader;
  final Widget stChevronRight;
  final VoidCallback onPress;

  const StRow({
    Key? key,
    required this.stHeader,
    required this.stChevronRight,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
          child: Row(
            children: [
              stHeader,
              Spacer(),
              stChevronRight,
            ],
          ),
        ),
      ),
    );
  }
}