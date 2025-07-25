import 'package:flutter/material.dart';

class VitalSignsScreen extends StatelessWidget {
  const VitalSignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vital Signs')),
      body: const Center(child: Text('Vital Signs Screen')),
    );
  }
}
