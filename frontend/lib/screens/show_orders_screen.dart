import 'package:flutter/material.dart';

class ShowOrdersScreen extends StatelessWidget {
  const ShowOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Orders')),
      body: const Center(child: Text('Show Orders Screen')),
    );
  }
}
