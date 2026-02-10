import 'package:flutter/material.dart';
import 'package:frontend/widgets/process_button.dart';

class GenerateReportScreen extends StatefulWidget {
  const GenerateReportScreen({super.key});

  @override
  State<GenerateReportScreen> createState() => _GenerateReportScreenState();
}

class _GenerateReportScreenState extends State<GenerateReportScreen> {
  String selectedMonth = 'February';
  int selectedYear = 2026;
  bool isReportGenerated = false;
  bool showPendingOrders = false;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<int> years = List.generate(10, (index) => 2024 + index);

  Widget _buildReportCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Monthly Report',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    spacing: 20,
                    children: [
                      // Month Dropdown
                      SizedBox(
                        width: 150,
                        height: 56,
                        child: DropdownButtonFormField<String>(
                          value: selectedMonth,
                          decoration: InputDecoration(
                            labelText: 'Month',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          items: months.map((month) {
                            return DropdownMenuItem<String>(
                              value: month,
                              child: Text(month),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMonth = value ?? 'February';
                            });
                          },
                        ),
                      ),
                      // Year Dropdown
                      SizedBox(
                        width: 120,
                        height: 56,
                        child: DropdownButtonFormField<int>(
                          value: selectedYear,
                          decoration: InputDecoration(
                            labelText: 'Year',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          items: years.map((year) {
                            return DropdownMenuItem<int>(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedYear = value ?? 2026;
                            });
                          },
                        ),
                      ),
                      // Generate Report Button
                      ProcessButton(
                        text: 'Generate Report',
                        buttonColor: Colors.blue,
                        onPressed: () {
                          setState(() {
                            isReportGenerated = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (isReportGenerated) ...[
                const SizedBox(height: 40),
                // Report Stats Cards
                Row(
                  spacing: 16,
                  children: [
                    _buildReportCard(
                      title: 'Total Orders Booked',
                      value: '0',
                      icon: Icons.inventory_2,
                      iconColor: Colors.orange,
                    ),
                    _buildReportCard(
                      title: 'Total Sales',
                      value: 'Rs. 0',
                      icon: Icons.monetization_on,
                      iconColor: Colors.amber,
                    ),
                    _buildReportCard(
                      title: 'Amount Received',
                      value: 'Rs. 0',
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                    ),
                    _buildReportCard(
                      title: 'Pending Amount',
                      value: 'Rs. 0',
                      icon: Icons.hourglass_top,
                      iconColor: Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Second row of stats
                Row(
                  spacing: 16,
                  children: [
                    _buildReportCard(
                      title: 'Delivered Orders',
                      value: '0',
                      icon: Icons.local_shipping,
                      iconColor: Colors.yellow,
                    ),
                    _buildReportCard(
                      title: 'Pending Orders',
                      value: '0',
                      icon: Icons.schedule,
                      iconColor: Colors.red,
                    ),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 40),
                // Action Buttons
                Row(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProcessButton(
                      text: 'View Pending Orders',
                      buttonColor: Colors.grey[700]!,
                      onPressed: () {
                        setState(() {
                          showPendingOrders = !showPendingOrders;
                        });
                      },
                    ),
                    ProcessButton(
                      text: 'Export PDF',
                      buttonColor: Colors.grey[600]!,
                      onPressed: () {},
                    ),
                    ProcessButton(
                      text: 'Export Excel',
                      buttonColor: Colors.grey[600]!,
                      onPressed: () {},
                    ),
                    ProcessButton(
                      text: 'Print',
                      buttonColor: Colors.blue,
                      onPressed: () {},
                    ),
                  ],
                ),
                if (showPendingOrders) ...[
                  const SizedBox(height: 40),
                  // Pending Orders Table
                  const Text(
                    'Pending Orders (Across All Time)',
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
                  // Table
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
                      rows: const [],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'No pending orders found. All orders are either delivered or ready to deliver!',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
