import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/customer_managment/presentation/controllers/customer_controller.dart';

class CustomerDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onAddPayment;
  final VoidCallback onEditCustomer;
  final VoidCallback onDeleteCustomer;
  final VoidCallback onDeactivatePressed;
  final CustomerController controller;

  const CustomerDetailsSheet({
    super.key,
    required this.customer,
    required this.onAddPayment,
    required this.onEditCustomer,
    required this.onDeleteCustomer,
    required this.onDeactivatePressed,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalDebt = (customer['totalDebt'] as num?)?.toDouble() ?? 0.0;

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer Details'.tr,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer profile section
                  Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'person',
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.4),
                              size: 10.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer['name']?.toString() ??
                                  'Unknown Customer'.tr,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Contact information
                  _buildDetailSection(
                    theme,
                    colorScheme,
                    'Contact Information'.tr,
                    [
                      _buildDetailRow(
                          'Phone Number'.tr,
                          customer['phoneNumber']?.toString() ??
                              'Not provided'.tr),
                      _buildDetailRow('Address'.tr,
                          customer['address']?.toString() ?? 'Not provided'.tr),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Notes
                  _buildDetailSection(
                    theme,
                    colorScheme,
                    'Notes'.tr,
                    [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            (customer['notes'] as String?)?.trim().isNotEmpty ==
                                    true
                                ? customer['notes']
                                : 'No notes available'.tr,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  //Debt information
                  _buildDetailSection(
                    theme,
                    colorScheme,
                    'Debt Information'.tr,
                    [
                      //debt
                      Obx(
                        () => controller.isLoading.value
                            ? _buildLoadingView(theme, colorScheme)
                            : SizedBox(
                                height: 25.h,
                                child: ListView.builder(
                                  itemCount: controller.debts.length,
                                  itemBuilder: (context, index) {
                                    final detail = controller.debts[index];
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Card(
                                            color: theme.cardColor,
                                            elevation: 2,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 1.h),
                                            child: Padding(
                                              padding: EdgeInsets.all(5.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildDetailRow(
                                                      'Amount:'.tr,
                                                      detail.amount
                                                          .toStringAsFixed(2)),
                                                  _buildDetailRow(
                                                      'Paid:'.tr,
                                                      detail.paidAmount
                                                          .toStringAsFixed(2)),
                                                  _buildDetailRow(
                                                      'Remaining:'.tr,
                                                      detail.remainingAmount
                                                          .toStringAsFixed(2)),
                                                  _buildDebtRow('Status:'.tr,
                                                      detail.status,
                                                      status: detail.status),
                                                  _buildDetailRow(
                                                      'Notes'.tr,
                                                      _formatDate(
                                                          detail.notes)),
                                                  _buildDetailRow(
                                                      'Due Date:'.tr,
                                                      _formatDate(
                                                          detail.dueDate)),
                                                  Divider(
                                                      thickness: 2,
                                                      color: colorScheme.outline
                                                          .withAlpha(77)),
                                                  Divider(
                                                    thickness: 2,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline
                                                        .withAlpha(77),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]);
                                  },
                                ),
                              ),
                      ),
                      _buildDetailRow('Total Debt'.tr,
                          'Sp ${totalDebt.toStringAsFixed(2)}'),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onAddPayment,
                        child: Text('Add Payment'.tr),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onEditCustomer,
                        child: Text('Edit Customer'.tr),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDeleteCustomer,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.error),
                        ),
                        child: Text(
                          'Delete'.tr,
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
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

  Widget _buildDetailSection(ThemeData theme, ColorScheme colorScheme,
      String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtRow(String label, String value, {String? status}) {
    Color statusColor = Colors.grey;
    if (status != null) {
      switch (status) {
        case 'PAID':
          statusColor = Colors.green;
          break;
        case 'ACTIVE':
          statusColor = Colors.orange;
          break;
        case 'OVERDUE':
          statusColor = Colors.red;
          break;
        default:
          statusColor = Colors.grey;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: status != null ? statusColor : Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Not available';

    try {
      final parsedDate = DateTime.parse(date.toString());
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (e) {
      return date.toString();
    }
  }

  Widget _buildLoadingView(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: CircularProgressIndicator(),
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading Debts...'.tr,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
