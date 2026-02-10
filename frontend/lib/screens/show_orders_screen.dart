import 'package:flutter/material.dart';

class ShowOrdersScreen extends StatelessWidget {
  const ShowOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.blue[700]!, width: 3),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Table Headers
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Customer Name')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Order Date')),
                  DataColumn(label: Text('Delivery Date')),
                  DataColumn(label: Text('Dress Type')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Total Amount')),
                  DataColumn(label: Text('Paid Amount')),
                  DataColumn(label: Text('Remaining')),
                  DataColumn(label: Text('Payment Status')),
                ],
                rows: const [], // Empty rows - will be populated from backend
              ),
            ),
            const SizedBox(height: 40),
            // Empty State Message
            Center(
              child: Text(
                'No orders found.',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
