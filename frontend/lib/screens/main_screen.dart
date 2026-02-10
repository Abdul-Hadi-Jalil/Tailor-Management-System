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
            title: const Text('Tailor CMS'),
            actions: [
              AppbarButton(text: 'Add Customer'),
              SizedBox(width: 4),
              AppbarButton(text: 'Add Measurement'),
              SizedBox(width: 4),
              AppbarButton(text: 'Add Order'),
              SizedBox(width: 4),
              AppbarButton(text: 'All Orders'),
              SizedBox(width: 4),
              AppbarButton(text: 'Search Customer'),
              SizedBox(width: 4),
              AppbarButton(text: 'Reports'),
              SizedBox(width: 50),
            ],
          ),
          body: _buildBody(screenState.currentScreen),
        );
      },
    );
  }
}
