import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/widgets/appbar_button.dart';
import 'package:frontend/provider/screen_state.dart';
import 'package:frontend/screens/add_customer_screen.dart';
import 'package:frontend/screens/add_measurement_screen.dart';
import 'package:frontend/screens/add_order_screen.dart';
import 'package:frontend/screens/show_orders_screen.dart';
import 'package:frontend/screens/search_customer_screen.dart';
import 'package:frontend/screens/generate_report_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Widget _buildBody(String currentScreen) {
    switch (currentScreen) {
      case 'addCustomer':
        return const AddCustomerScreen();
      case 'addMeasurement':
        return const AddMeasurementScreen();
      case 'addOrder':
        return const AddOrderScreen();
      case 'showOrders':
        return const ShowOrdersScreen();
      case 'searchCustomer':
        return const SearchCustomerScreen();
      case 'generateReport':
        return const GenerateReportScreen();
      default:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to Tailor CMS!', style: TextStyle(fontSize: 24)),
              Text("Select an option from the menu to get started."),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScreenState>(
      builder: (context, screenState, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[800],
            title: Row(
              children: [
                Icon(Icons.restaurant, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Tailor CMS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              AppbarButton(text: 'Add Customer'),
              const SizedBox(width: 12),
              AppbarButton(text: 'Search'),
              const SizedBox(width: 12),
              AppbarButton(text: 'Orders'),
              const SizedBox(width: 12),
              AppbarButton(text: 'All Orders'),
              const SizedBox(width: 12),
              AppbarButton(text: 'Measurements'),
              const SizedBox(width: 12),
              AppbarButton(text: 'Reports'),
              const SizedBox(width: 24),
            ],
          ),
          body: _buildBody(screenState.currentScreen),
        );
      },
    );
  }
}
