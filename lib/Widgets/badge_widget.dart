import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String text;
  final Color color;

  const BadgeWidget({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}
