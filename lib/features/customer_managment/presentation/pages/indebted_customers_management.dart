import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/core/params/params.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.fetchCustomers();
    });
  }

  void _showCustomerDetails(Map<String, dynamic> customer) {
    customerController.fetchDebts(customer['id']);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerDetailsSheet(
        customer: customer,
        onAddPayment: () => _showAddPaymentSheet(customer),
        onEditCustomer: () => _editCustomer(customer),
        onDeleteCustomer: () => _deleteCustomer(customer),
        onDeactivatePressed: () {},
        controller: customerController,
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
          final param = PaymentParams(
            totalPaymentAmount: paymentData['totalPaymentAmount'],
            paymentMethod: paymentData['paymentMethod'],
            notes: paymentData['notes'],
          );
          customerController.addPayment(paymentData['customerId'], param);
        },
      ),
    );
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

/////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Indebted Customers'.tr),
        actions: [
          IconButton(
            onPressed: () => customerController.refreshData(),
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
                        customerController.refreshData;
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
                                  print('--------0--${customer.totalDebt}');
                                  return IndebtedCustomerCard(
                                    customer: {
                                      "id": customer.id,
                                      "name": customer.name,
                                      "phoneNumber": customer.phoneNumber,
                                      "address": customer.address,
                                      "totalDebt": customer.totalDebt,
                                      "totalPaid": customer.totalPaid,
                                      "remainingDebt": customer.remainingDebt,
                                      "activeDebtsCount":
                                          customer.activeDebtsCount,
                                      "debts": customer.debts,
                                      "notes": customer.notes
                                    },
                                    onTap: () => _showCustomerDetails({
                                      "id": customer.id,
                                      "name": customer.name,
                                      "phoneNumber": customer.phoneNumber,
                                      "address": customer.address,
                                      "totalDebt": customer.totalDebt,
                                      "totalPaid": customer.totalPaid,
                                      "remainingDebt": customer.remainingDebt,
                                      "activeDebtsCount":
                                          customer.activeDebtsCount,
                                      "debts": customer.debts,
                                      "notes": customer.notes
                                    }),
                                    onAddPayment: () => _showAddPaymentSheet({
                                      "id": customer.id,
                                      "name": customer.name,
                                      "phoneNumber": customer.phoneNumber,
                                      "address": customer.address,
                                      "totalDebt": customer.totalDebt,
                                      "totalPaid": customer.totalPaid,
                                      "remainingDebt": customer.remainingDebt,
                                      "activeDebtsCount":
                                          customer.activeDebtsCount,
                                      "debts": customer.debts,
                                      "notes": customer.notes
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
        heroTag: null,
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
