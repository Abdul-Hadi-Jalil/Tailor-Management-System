import 'package:flutter/material.dart';

class SearchCustomerScreen extends StatelessWidget {
  const SearchCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Customer')),
      body: const Center(child: Text('Search Customer Screen')),
    );
  }
}
