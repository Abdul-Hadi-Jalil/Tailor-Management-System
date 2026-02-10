import 'package:flutter/material.dart';
import 'package:frontend/widgets/process_button.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _manualOrderController = TextEditingController();
  final TextEditingController _designNoController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController(
    text: '0',
  );
  final TextEditingController _balanceController = TextEditingController(
    text: '0',
  );
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _manualBookController = TextEditingController();
  final TextEditingController _deliveredByController = TextEditingController();

  String selectedStatus = 'Order';
  String selectedDressType = 'Select Dress Type';
  String selectedCustomer = 'No Customer Selected';
  DateTime orderDate = DateTime.now();
  DateTime deliveryDate = DateTime.now();
  DateTime? outDate;
  DateTime? tryDate;

  @override
  void dispose() {
    _searchController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _manualOrderController.dispose();
    _designNoController.dispose();
    _quantityController.dispose();
    _totalAmountController.dispose();
    _advanceController.dispose();
    _balanceController.dispose();
    _remarksController.dispose();
    _manualBookController.dispose();
    _deliveredByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Customer Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  spacing: 12,
                  children: [
                    const Text(
                      'Search Customer:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Enter Phone or Name...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ProcessButton(
                      text: 'Search',
                      buttonColor: Colors.green,
                      onPressed: () {},
                      padding: 12,
                    ),
                    Text(
                      selectedCustomer,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Main Form
              Row(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabeledField('Cust Phone:', _phoneController),
                          const SizedBox(height: 12),
                          _buildLabeledField('Customer Name:', _nameController),
                          const SizedBox(height: 12),
                          _buildLabeledField('Address:', _addressController),
                          const SizedBox(height: 12),
                          _buildLabeledField(
                            'Manual Order No:',
                            _manualOrderController,
                          ),
                          const SizedBox(height: 12),
                          _buildDateField('Order Date:', orderDate, (picked) {
                            setState(() => orderDate = picked);
                          }),
                          const SizedBox(height: 12),
                          _buildDateField('Delivery Date:', deliveryDate, (
                            picked,
                          ) {
                            setState(() => deliveryDate = picked);
                          }),
                          const SizedBox(height: 12),
                          _buildDateField('Out Date:', outDate),
                          const SizedBox(height: 12),
                          _buildDateField('Try Date:', tryDate),
                        ],
                      ),
                    ),
                  ),
                  // Right Column
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDropdown(
                            'Status:',
                            selectedStatus,
                            ['Order', 'Pending', 'Delivered'],
                            (value) => setState(() => selectedStatus = value),
                          ),
                          const SizedBox(height: 12),
                          _buildLabeledField('Quantity:', _quantityController),
                          const SizedBox(height: 12),
                          _buildLabeledField('Design No:', _designNoController),
                          const SizedBox(height: 12),
                          _buildDropdown(
                            'Dress Type *:',
                            selectedDressType,
                            ['Select Dress Type', 'Shirt', 'Pants', 'Suit'],
                            (value) =>
                                setState(() => selectedDressType = value),
                          ),
                          const SizedBox(height: 12),
                          _buildLabeledField(
                            'Total Amount:',
                            _totalAmountController,
                          ),
                          const SizedBox(height: 12),
                          _buildLabeledField('Advance:', _advanceController),
                          const SizedBox(height: 12),
                          // Balance Display
                          const Text(
                            'Balance:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildLabeledField('Remarks:', _remarksController),
                          const SizedBox(height: 12),
                          _buildLabeledField(
                            'Manual Book No:',
                            _manualBookController,
                          ),
                          const SizedBox(height: 12),
                          _buildLabeledField(
                            'Delivered by:',
                            _deliveredByController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Bottom Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  ProcessButton(
                    text: '✓ Add',
                    buttonColor: Colors.green[700]!,
                    onPressed: () {},
                    padding: 16,
                  ),
                  ProcessButton(
                    text: 'New Order',
                    buttonColor: Colors.green[600]!,
                    onPressed: () {},
                    padding: 16,
                  ),
                  ProcessButton(
                    text: '✕ Close',
                    buttonColor: Colors.red,
                    onPressed: () {},
                    padding: 16,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? date, [
    Function(DateTime)? onDatePicked,
  ]) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                hintText: date == null
                    ? 'mm/dd/yyyy'
                    : '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: date ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && onDatePicked != null) {
                      onDatePicked(picked);
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 40,
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: (val) => onChanged(val ?? value),
            ),
          ),
        ),
      ],
    );
  }
}
