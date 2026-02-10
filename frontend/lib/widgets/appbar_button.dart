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
      case 'Add Measurement':
        return 'addMeasurement';
      case 'Add Order':
        return 'addOrder';
      case 'All Orders':
        return 'showOrders';
      case 'Search Customer':
        return 'searchCustomer';
      case 'Reports':
        return 'generateReport';
      default:
        return 'main';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final screenState = context.read<ScreenState>();
        screenState.changeScreen(_getScreenName(text));
      },
      child: Text(text),
    );
  }
}
