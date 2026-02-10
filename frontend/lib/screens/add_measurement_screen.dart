import 'package:flutter/material.dart';
import 'package:frontend/widgets/process_button.dart';

class AddMeasurementScreen extends StatelessWidget {
  const AddMeasurementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Manage Measurements',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // customer information form
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  spacing: 12,
                  children: [
                    const Text(
                      "Search Customer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter customer name or phone",
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
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    ProcessButton(
                      padding: 21,
                      text: "Search",
                      buttonColor: Colors.green,
                      onPressed: () {
                        // Implement search action here
                      },
                    ),
                    const Text(
                      "Selected Customer: John Doe",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
