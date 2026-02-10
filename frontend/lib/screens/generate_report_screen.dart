import 'package:flutter/material.dart';

class GenerateReportScreen extends StatelessWidget {
  const GenerateReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(child: Text('Generate Report Screen')),
    );
  }
}
