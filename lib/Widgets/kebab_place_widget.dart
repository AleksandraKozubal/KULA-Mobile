import 'package:flutter/material.dart';

class KebabPlaceWidget extends StatelessWidget {
  const KebabPlaceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Kebab Places'),
      ),
      body: const Center(
      ),
    );
  }
}