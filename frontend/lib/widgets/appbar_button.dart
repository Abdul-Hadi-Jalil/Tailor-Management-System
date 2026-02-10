import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/provider/screen_state.dart';

class AppbarButton extends StatelessWidget {
  final String text;
  const AppbarButton({super.key, required this.text});

  String _getScreenName(String buttonText) {
    switch (buttonText) {
      case 'Add Customer':
        return 'addCustomer';
      case 'Search':
        return 'searchCustomer';
      case 'Orders':
        return 'addOrder';
      case 'All Orders':
        return 'showOrders';
      case 'Measurements':
        return 'addMeasurement';
      case 'Reports':
        return 'generateReport';
      default:
        return 'main';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () {
        final screenState = context.read<ScreenState>();
        screenState.changeScreen(_getScreenName(text));
      },
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
