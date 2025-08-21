import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/features/customer_managment/presentation/controllers/customer_controller.dart';
import 'package:teriak/features/customer_managment/presentation/widgets/customer_details_sheet.dart';
import 'package:teriak/features/customer_managment/presentation/widgets/debt_search_bar.dart';
import 'package:teriak/features/customer_managment/presentation/widgets/indebted_customer_card.dart';
import 'package:teriak/features/customer_managment/presentation/widgets/payment_bottom_sheet.dart';

class IndebtedCustomersManagement extends StatefulWidget {
  const IndebtedCustomersManagement({super.key});

  @override
  State<IndebtedCustomersManagement> createState() =>
      _IndebtedCustomersManagementState();
}

class _IndebtedCustomersManagementState
    extends State<IndebtedCustomersManagement> {
  CustomerController customerController = Get.put(CustomerController());

  // ignore: unused_field
  final List<Map<String, dynamic>> _allCustomers = [];
  final List<Map<String, dynamic>> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.fetchCustomers();
    });
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

    final customerIndex =
        customerController.customers.indexWhere((c) => c.id == customerId);
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
    Navigator.pushNamed(context, AppPages.addNewIndebtedCustomer,
        arguments: customer);
  }

  void _deleteCustomer(Map<String, dynamic> customer) {
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Customer'.tr),
        content: Text(
            '${'Are you sure you want to remove'.tr} ${customer['name']} ${'from indebted customers?'.tr}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              customerController.deleteCustomer(customer['id']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Delete'.tr),
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

/////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Indebted Customers'.tr,
        actions: [
          IconButton(
            onPressed: _showBulkActions,
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: customerController.refresh,
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
            onSearchChanged: (value) {
              customerController.results.clear();
              customerController.search(value.trim());
              print('Searching foooooor: $value');
            },
            searchController: customerController.searchController,
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
          Obx(
            () => Expanded(
              child: customerController.isLoading.value
                  ? _buildLoadingView(theme, colorScheme)
                  : RefreshIndicator(
                      onRefresh: () async {
                        customerController.refresh;
                      },
                      child: customerController.customers.isEmpty
                          ? _buildEmptyView(theme, colorScheme)
                          : Obx(() {
                              if (customerController.isLoading.value) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              final dataSource = customerController
                                      .searchController.text.isNotEmpty
                                  ? customerController.results
                                  : customerController.customers;

                              if (dataSource.isEmpty) {
                                return _buildEmptyView(theme, colorScheme);
                              }

                              return ListView.builder(
                                padding: EdgeInsets.only(bottom: 10.h),
                                itemCount: dataSource.length,
                                itemBuilder: (context, index) {
                                  final customer = dataSource[index];
                                  return IndebtedCustomerCard(
                                    customer: {
                                      "id": customer.id,
                                      "name": customer.name,
                                      "phoneNumber": customer.phoneNumber,
                                      "address": customer.address,
                                      "totalDebt": 0.0,
                                      "totalPaid": 0.0,
                                      "remainingDebt": 0.0,
                                      "activeDebtsCount": 0.0,
                                      "debts": null,
                                      "notes": customer.notes
                                    },
                                    onTap: () => _showCustomerDetails({
                                      "id": customer.id,
                                      "name": customer.name,
                                      "phoneNumber": customer.phoneNumber,
                                      "address": customer.address,
                                      "notes": customer.notes
                                    }),
                                    onAddPayment: () => _showAddPaymentSheet({
                                      "id": customer.id,
                                      "name": customer.name,
                                    }),
                                    onSendReminder: () => _sendPaymentReminder({
                                      "name": customer.name,
                                    }),
                                  );
                                },
                              );
                            }),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppPages.addNewIndebtedCustomer);
        },
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
            'Loading customers...'.tr,
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
            'No indebted customers found'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
