import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final String text;
  final Color color;
  final bool solid;

  const BadgeWidget({
    required this.text,
    required this.color,
    this.solid = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: solid ? color : Colors.transparent,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: solid ? Colors.white : color),
      ),
    );
  }
}
