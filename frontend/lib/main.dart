import 'package:flutter/material.dart';

void main() {
  runApp(const TailorCMS());
}

class TailorCMS extends StatelessWidget {
  const TailorCMS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tailor CMS',
      theme: ThemeData(
        primaryColor: const Color(0xFF2D5B7A), // Main blue
        secondaryHeaderColor: const Color(0xFF4CAF50), // Green
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF2196F3),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Main Screen with Navigation and Content Area
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentScreen = 'home';
  final List<String> _historyStack = [];

  // Navigation handler
  void _navigateTo(String screenName, {bool addToHistory = true}) {
    setState(() {
      if (addToHistory && _currentScreen != 'home') {
        _historyStack.add(_currentScreen);
      }
      if (screenName == 'home') {
        _historyStack.clear();
      }
      _currentScreen = screenName;
    });
  }

  // Back handler
  void _handleBack() {
    if (_historyStack.isNotEmpty) {
      final previousScreen = _historyStack.removeLast();
      _navigateTo(previousScreen, addToHistory: false);
    } else {
      _navigateTo('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Header / Persistent Navigation
          _buildAppHeader(),

          // Main Content Area
          Expanded(child: _buildCurrentScreen()),
        ],
      ),
    );
  }

  // App Header Widget
  Widget _buildAppHeader() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Left: Logo / Home
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _navigateTo('home'),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    const Icon(
                      Icons.linear_scale,
                      size: 28,
                      color: Color(0xFF2D5B7A),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tailor CMS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D5B7A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Center: Main Navigation
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavButton(
                    'addCustomer',
                    Icons.person_add,
                    'Add Customer',
                  ),
                  const SizedBox(width: 8),
                  _buildNavButton('searchCustomer', Icons.search, 'Search'),
                  const SizedBox(width: 8),
                  _buildNavButton('addOrder', Icons.note_add, 'Orders'),
                  const SizedBox(width: 8),
                  _buildNavButton('allOrders', Icons.list, 'All Orders'),
                  const SizedBox(width: 8),
                  _buildNavButton(
                    'measurements',
                    Icons.straighten,
                    'Measurements',
                  ),
                  const SizedBox(width: 8),
                  _buildNavButton('monthlyReport', Icons.bar_chart, 'Reports'),
                ],
              ),
            ),
          ),

          // Right: Back Button
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Visibility(
                visible: _currentScreen != 'home',
                child: TextButton.icon(
                  onPressed: _handleBack,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Back'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2D5B7A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Button Widget
  Widget _buildNavButton(String screen, IconData icon, String label) {
    final isActive = _currentScreen == screen;
    return TextButton.icon(
      onPressed: () => _navigateTo(screen),
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Colors.white : const Color(0xFF2D5B7A),
        backgroundColor: isActive
            ? const Color(0xFF2D5B7A)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  // Screen Content Switcher
  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case 'home':
        return _buildHomeScreen();
      case 'addCustomer':
        return _buildAddCustomerScreen();
      case 'searchCustomer':
        return _buildSearchCustomerScreen();
      case 'addOrder':
        return _buildAddOrderScreen();
      case 'allOrders':
        return _buildAllOrdersScreen();
      case 'monthlyReport':
        return _buildMonthlyReportScreen();
      default:
        return _buildHomeScreen();
    }
  }

  // ============ SCREEN WIDGETS ============

  // 1. Home Screen
  Widget _buildHomeScreen() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.linear_scale,
            size: 80,
            color: const Color(0xFF2D5B7A).withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome to Tailor CMS',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5B7A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select an option from the top menu to get started.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 2. Add Customer Screen
  Widget _buildAddCustomerScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Customer',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),

          // Customer Information Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customer Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),

                // Form Grid
                const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Full Name *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number *',
                          hintText: '03001234567',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),

                // Action Buttons
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                      ),
                      child: const Text('Save & Add Another'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Continue to Measurements →'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Search Customer Screen
  Widget _buildSearchCustomerScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Advanced Search',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Advanced Search Grid
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '0300...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Date (Order/Delivery)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: '',
                            child: Text('All Categories'),
                          ),
                          DropdownMenuItem(
                            value: 'shalwar',
                            child: Text('Shalwar Kameez'),
                          ),
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Manual Order No',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Search Records'),
                  ),
                ),
              ],
            ),
          ),

          // Results Area
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(Icons.search_off, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No records found matching your criteria.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 4. Add Order Screen (Legacy Style)
  Widget _buildAddOrderScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Cyan Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF00BCD4),
            child: const Text(
              'Add Order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Search Customer:',
                            hintText: 'Enter Phone or Name...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                        ),
                        child: const Text('Search'),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'No Customer Selected',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Form
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      // Two Column Grid
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column
                          Expanded(
                            child: Column(
                              children: [
                                _buildLegacyField('Cust Phone:', true),
                                const SizedBox(height: 12),
                                _buildLegacyField('Customer Name:', true),
                                const SizedBox(height: 12),
                                _buildLegacyField('Address:', true),
                                const SizedBox(height: 12),
                                _buildLegacyField('Manual Order No:', false),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Order Date:',
                                  false,
                                  isDate: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Delivery Date:',
                                  false,
                                  isDate: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Out Date:',
                                  false,
                                  isDate: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Try Date:',
                                  false,
                                  isDate: true,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 32),

                          // Right Column
                          Expanded(
                            child: Column(
                              children: [
                                _buildLegacyField(
                                  'Status:',
                                  false,
                                  isDropdown: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Quantity:',
                                  false,
                                  isNumber: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField('Design No:', false),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Dress Type *:',
                                  false,
                                  isDropdown: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Total Amount:',
                                  false,
                                  isNumber: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Advance:',
                                  false,
                                  isNumber: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField(
                                  'Balance:',
                                  true,
                                  isNumber: true,
                                ),
                                const SizedBox(height: 12),
                                _buildLegacyField('Remarks:', false),
                                const SizedBox(height: 12),
                                _buildLegacyField('Manual Book No:', false),
                                const SizedBox(height: 12),
                                _buildLegacyField('Delivered by:', false),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Footer Buttons
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('✔ Add'),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('✖ Close'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Legacy Field Builder Helper
  Widget _buildLegacyField(
    String label,
    bool isReadOnly, {
    bool isDate = false,
    bool isDropdown = false,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        if (isDropdown)
          DropdownButtonFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(value: '1', child: Text('Option 1')),
            ],
            onChanged: (value) {},
          )
        else
          TextField(
            readOnly: isReadOnly,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              suffixIcon: isDate
                  ? const Icon(Icons.calendar_today, size: 18)
                  : null,
            ),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          ),
      ],
    );
  }

  // 5. All Orders Screen
  Widget _buildAllOrdersScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Orders',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sorted by Order Date (newest first)',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Table
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order ID')),
                  DataColumn(label: Text('Manual Order No')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Order Date')),
                  DataColumn(label: Text('Delivery Date')),
                  DataColumn(label: Text('Dress Type')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Paid')),
                  DataColumn(label: Text('Balance')),
                ],
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('MO-001')),
                      DataCell(Text('Ahmed Khan')),
                      DataCell(Text('03001234567')),
                      DataCell(Text('15/01/2024')),
                      DataCell(Text('25/01/2024')),
                      DataCell(Text('Shalwar Kameez')),
                      DataCell(Text('Stitching')),
                      DataCell(Text('Rs. 5,000')),
                      DataCell(Text('Rs. 2,000')),
                      DataCell(Text('Rs. 3,000')),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Center(
            child: Text(
              'No orders in the system.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // 6. Monthly Report Screen
  Widget _buildMonthlyReportScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Report',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Filters
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('January')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '2024', child: Text('2024')),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Generate Report'),
                ),
              ],
            ),
          ),

          // Report Cards
          const SizedBox(height: 32),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard('📦', 'Total Orders Booked', '0'),
              _buildStatCard('💰', 'Total Sales', 'Rs. 0'),
              _buildStatCard('✅', 'Amount Received', 'Rs. 0'),
              _buildStatCard('⏳', 'Pending Amount', 'Rs. 0'),
              _buildStatCard('🎉', 'Delivered Orders', '0'),
              _buildStatCard('⏰', 'Pending Orders', '0'),
            ],
          ),

          // Action Buttons
          const SizedBox(height: 32),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Text('View Pending Orders'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: () {}, child: const Text('Export PDF')),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Export Excel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: () {}, child: const Text('Print')),
            ],
          ),
        ],
      ),
    );
  }

  // Stat Card Widget for Monthly Report
  Widget _buildStatCard(String icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
