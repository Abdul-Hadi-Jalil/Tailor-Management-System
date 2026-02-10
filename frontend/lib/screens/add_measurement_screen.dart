import 'package:flutter/material.dart';

class AddMeasurementScreen extends StatelessWidget {
  const AddMeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Measurement')),
      body: const Center(child: Text('Add Measurement Screen')),
    );
  }
}
