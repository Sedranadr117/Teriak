import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/config/widgets/custom_tab_bar.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/customer_details_sheet.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/debt_filter_sheet.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/debt_search_bar.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/indebted_customer_card.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/payment_bottom_sheet.dart';

class IndebtedCustomersManagement extends StatefulWidget {
  const IndebtedCustomersManagement({super.key});

  @override
  State<IndebtedCustomersManagement> createState() =>
      _IndebtedCustomersManagementState();
}

class _IndebtedCustomersManagementState
    extends State<IndebtedCustomersManagement> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {
    'debtStatus': 'All Debts',
    'minAmount': 0.0,
    'maxAmount': 5000.0,
    'overdueOnly': false,
    'sortBy': 'Name',
  };

  bool _isLoading = false;
  // ignore: unused_field
  bool _isRefreshing = false;
  List<Map<String, dynamic>> _allCustomers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];

  final List<TabItem> _tabs = [
    TabItem(label: 'Indebted', icon: Icons.account_balance_wallet_outlined),
    TabItem(label: 'Overdue', icon: Icons.warning_amber_outlined),
    TabItem(label: 'Current', icon: Icons.check_circle_outline),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadIndebtedCustomers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadIndebtedCustomers() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 1500));

    // Mock indebted customers data
    _allCustomers = [
      {
        'id': 1,
        'name': 'Sarah Johnson',
        'phone': '+1 (555) 123-4567',
        'email': 'sarah.johnson@email.com',
        'address': '123 Main St, Springfield',
        'totalDebt': 245.75,
        'lastPayment': '2024-01-15',
        'dueDate': '2024-02-15',
        'paymentTerms': '30 days',
        'notes': 'Regular customer, good payment history',
        'profileImage':
            'https://images.unsplash.com/photo-1494790108755-2616b612b1c5?w=150&h=150&fit=crop&crop=face',
        'isOverdue': true,
        'daysPastDue': 15,
        'paymentHistory': [
          {'date': '2024-01-15', 'amount': 150.25, 'type': 'Payment'},
          {'date': '2023-12-20', 'amount': 300.00, 'type': 'Purchase'},
        ],
      },
      {
        'id': 2,
        'name': 'Michael Chen',
        'phone': '+1 (555) 987-6543',
        'email': 'michael.chen@email.com',
        'address': '456 Oak Avenue, Downtown',
        'totalDebt': 89.50,
        'lastPayment': '2024-01-28',
        'dueDate': '2024-02-28',
        'paymentTerms': '30 days',
        'notes': 'New customer, requires payment reminders',
        'profileImage':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        'isOverdue': false,
        'daysPastDue': 0,
        'paymentHistory': [
          {'date': '2024-01-28', 'amount': 200.00, 'type': 'Payment'},
          {'date': '2024-01-10', 'amount': 289.50, 'type': 'Purchase'},
        ],
      },
      {
        'id': 3,
        'name': 'Emily Rodriguez',
        'phone': '+1 (555) 246-8135',
        'email': 'emily.rodriguez@email.com',
        'address': '789 Pine Street, Uptown',
        'totalDebt': 567.25,
        'lastPayment': '2023-12-01',
        'dueDate': '2024-01-01',
        'paymentTerms': '30 days',
        'notes': 'Long-standing customer, payment plan needed',
        'profileImage':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        'isOverdue': true,
        'daysPastDue': 45,
        'paymentHistory': [
          {'date': '2023-12-01', 'amount': 100.00, 'type': 'Payment'},
          {'date': '2023-11-15', 'amount': 667.25, 'type': 'Purchase'},
        ],
      },
      {
        'id': 4,
        'name': 'David Thompson',
        'phone': '+1 (555) 369-7412',
        'email': 'david.thompson@email.com',
        'address': '321 Elm Drive, Westside',
        'totalDebt': 125.00,
        'lastPayment': '2024-01-20',
        'dueDate': '2024-02-20',
        'paymentTerms': '30 days',
        'notes': 'Reliable customer, prompt payments',
        'profileImage':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        'isOverdue': false,
        'daysPastDue': 0,
        'paymentHistory': [
          {'date': '2024-01-20', 'amount': 75.00, 'type': 'Payment'},
          {'date': '2024-01-05', 'amount': 200.00, 'type': 'Purchase'},
        ],
      },
      {
        'id': 5,
        'name': 'Lisa Martinez',
        'phone': '+1 (555) 159-7531',
        'email': 'lisa.martinez@email.com',
        'address': '654 Maple Lane, Eastside',
        'totalDebt': 312.80,
        'lastPayment': '2024-01-10',
        'dueDate': '2024-02-10',
        'paymentTerms': '30 days',
        'notes': 'Frequent customer, prefers monthly payments',
        'profileImage':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face',
        'isOverdue': false,
        'daysPastDue': 0,
        'paymentHistory': [
          {'date': '2024-01-10', 'amount': 187.20, 'type': 'Payment'},
          {'date': '2023-12-28', 'amount': 500.00, 'type': 'Purchase'},
        ],
      },
    ];

    _applyFilters();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshCustomers() async {
    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();
    await _loadIndebtedCustomers();

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Customer debts synchronized successfully'.tr),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allCustomers);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((customer) {
        final name = (customer['name'] as String? ?? '').toLowerCase();
        final phone = (customer['phone'] as String? ?? '').toLowerCase();
        final email = (customer['email'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            phone.contains(query) ||
            email.contains(query);
      }).toList();
    }

    // Apply debt status filter
    if (_currentFilters['debtStatus'] != 'All Debts') {
      filtered = filtered.where((customer) {
        final isOverdue = customer['isOverdue'] as bool? ?? false;
        final totalDebt = (customer['totalDebt'] as num?)?.toDouble() ?? 0.0;

        switch (_currentFilters['debtStatus']) {
          case 'Current':
            return !isOverdue && totalDebt > 0;
          case 'Overdue':
            return isOverdue;
          case 'Paid':
            return totalDebt == 0;
          default:
            return true;
        }
      }).toList();
    }

    // Apply amount range filter
    final minAmount = (_currentFilters['minAmount'] as num?)?.toDouble() ?? 0.0;
    final maxAmount =
        (_currentFilters['maxAmount'] as num?)?.toDouble() ?? 5000.0;
    filtered = filtered.where((customer) {
      final debt = (customer['totalDebt'] as num?)?.toDouble() ?? 0.0;
      return debt >= minAmount && debt <= maxAmount;
    }).toList();

    // Apply overdue filter
    if (_currentFilters['overdueOnly'] == true) {
      filtered = filtered.where((customer) {
        return customer['isOverdue'] as bool? ?? false;
      }).toList();
    }

    // Apply tab-specific filters
    switch (_tabController.index) {
      case 1: // Overdue
        filtered = filtered.where((customer) {
          return customer['isOverdue'] as bool? ?? false;
        }).toList();
        break;
      case 2: // Current
        filtered = filtered.where((customer) {
          final isOverdue = customer['isOverdue'] as bool? ?? false;
          final totalDebt = (customer['totalDebt'] as num?)?.toDouble() ?? 0.0;
          return !isOverdue && totalDebt > 0;
        }).toList();
        break;
    }

    // Apply sorting
    switch (_currentFilters['sortBy']) {
      case 'Name':
        filtered.sort((a, b) =>
            (a['name'] as String? ?? '').compareTo(b['name'] as String? ?? ''));
        break;
      case 'Debt Amount':
        filtered.sort((a, b) => (b['totalDebt'] as num? ?? 0)
            .compareTo(a['totalDebt'] as num? ?? 0));
        break;
      case 'Due Date':
        filtered.sort((a, b) {
          final aDate = DateTime.tryParse(a['dueDate'] as String? ?? '') ??
              DateTime.now();
          final bDate = DateTime.tryParse(b['dueDate'] as String? ?? '') ??
              DateTime.now();
          return aDate.compareTo(bDate);
        });
        break;
    }

    setState(() {
      _filteredCustomers = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DebtFilterSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _showCustomerDetails(Map<String, dynamic> customer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerDetailsSheet(
        customer: customer,
        onAddPayment: () => _showAddPaymentSheet(customer),
        onEditCustomer: () => _editCustomer(customer),
        onDeleteCustomer: () => _deleteCustomer(customer),
        onSendReminder: () => _sendPaymentReminder(customer),
        onSetPaymentPlan: () => _setPaymentPlan(customer),
      ),
    );
  }

  void _showAddPaymentSheet(Map<String, dynamic> customer) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentBottomSheet(
        customer: customer,
        onPaymentSubmitted: (paymentData) {
          _processPayment(paymentData);
        },
      ),
    );
  }

  void _processPayment(Map<String, dynamic> paymentData) {
    final customerId = paymentData['customerId'];
    final amount = paymentData['amount'] as double;

    // Find and update the customer
    final customerIndex =
        _allCustomers.indexWhere((c) => c['id'] == customerId);
    if (customerIndex != -1) {
      final currentDebt =
          (_allCustomers[customerIndex]['totalDebt'] as num).toDouble();
      final newDebt = (currentDebt - amount).clamp(0.0, double.infinity);

      setState(() {
        _allCustomers[customerIndex]['totalDebt'] = newDebt;
        _allCustomers[customerIndex]['lastPayment'] =
            DateTime.now().toIso8601String().split('T')[0];

        // Update overdue status if debt is paid or reduced
        if (newDebt == 0) {
          _allCustomers[customerIndex]['isOverdue'] = false;
          _allCustomers[customerIndex]['daysPastDue'] = 0;
        }

        // Add to payment history
        final paymentHistory = _allCustomers[customerIndex]['paymentHistory']
            as List<Map<String, dynamic>>;
        paymentHistory.insert(0, {
          'date': DateTime.now().toIso8601String().split('T')[0],
          'amount': amount,
          'type': 'Payment',
        });
      });

      _applyFilters();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Payment of \$${amount.toStringAsFixed(2)} recorded successfully"
                  .tr),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _editCustomer(Map<String, dynamic> customer) {
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      AppPages.addNewIndebtedCustomer,
      arguments: customer,
    ).then((_) => _loadIndebtedCustomers());
  }

  void _deleteCustomer(Map<String, dynamic> customer) {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Customer'),
        content: Text(
            'Are you sure you want to remove ${customer['name']} from indebted customers?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                _allCustomers.removeWhere((c) => c['id'] == customer['id']);
              });
              _applyFilters();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${customer['name']} removed successfully".tr),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _sendPaymentReminder(Map<String, dynamic> customer) {
    Navigator.pop(context);
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment reminder sent to ${customer['name']}".tr),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _setPaymentPlan(Map<String, dynamic> customer) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment plan setup for ${customer['name']}".tr),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addNewIndebtedCustomer() {
    Navigator.pushNamed(context, AppPages.addNewIndebtedCustomer)
        .then((_) => _loadIndebtedCustomers());
  }

  void _showBulkActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Send Bulk Reminders'),
              onTap: () {
                Navigator.pop(context);
                _sendBulkReminders();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'assessment',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Generate Debt Report'),
              onTap: () {
                Navigator.pop(context);
                _generateDebtReport();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'payment',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Process Bulk Payments'),
              onTap: () {
                Navigator.pop(context);
                _processBulkPayments();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendBulkReminders() {
    final overdueCustomers =
        _filteredCustomers.where((c) => c['isOverdue'] == true).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Reminders sent to $overdueCustomers overdue customers".tr),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _generateDebtReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Debt report generated successfully".tr),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _processBulkPayments() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bulk payment processing initiated".tr),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Indebted Customers',
        actions: [
          IconButton(
            onPressed: _showBulkActions,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
            tooltip: 'Bulk Actions',
          ),
          IconButton(
            onPressed: _refreshCustomers,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          DebtSearchBar(
            onSearchChanged: _onSearchChanged,
            onFilterPressed: _showFilterBottomSheet,
          ),
          CustomTabBar(
            tabs: _tabs,
            controller: _tabController,
            onTap: (index) {
              _applyFilters();
            },
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingView(theme, colorScheme)
                : RefreshIndicator(
                    onRefresh: _refreshCustomers,
                    child: _filteredCustomers.isEmpty
                        ? _buildEmptyView(theme, colorScheme)
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 10.h),
                            itemCount: _filteredCustomers.length,
                            itemBuilder: (context, index) {
                              final customer = _filteredCustomers[index];
                              return IndebtedCustomerCard(
                                customer: customer,
                                onTap: () => _showCustomerDetails(customer),
                                onAddPayment: () =>
                                    _showAddPaymentSheet(customer),
                                onSendReminder: () =>
                                    _sendPaymentReminder(customer),
                                onCall: () => _callCustomer(customer),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewIndebtedCustomer,
        tooltip: 'Add New Indebted Customer',
        child: CustomIconWidget(
          iconName: 'person_add',
          color: colorScheme.onPrimary,
          size: 7.w,
        ),
      ),
    );
  }

  Widget _buildLoadingView(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 2.h),
          Text(
            'Loading customers...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            size: 20.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No indebted customers found',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search or filters',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _currentFilters = {
                  'debtStatus': 'All Debts',
                  'minAmount': 0.0,
                  'maxAmount': 5000.0,
                  'overdueOnly': false,
                  'sortBy': 'Name',
                };
              });
              _applyFilters();
            },
            child: Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  void _callCustomer(Map<String, dynamic> customer) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Calling ${customer['name']}...".tr),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
