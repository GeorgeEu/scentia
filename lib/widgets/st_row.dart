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
        child: Container(
          padding: EdgeInsets.only(left: 16),
          height: 52,
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