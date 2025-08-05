import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';

class SupplierStatsWidget extends StatelessWidget {
  const SupplierStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GetBuilder<GetAllSupplierController>(
      builder: (controller) {
        final suppliers = controller.suppliers;

        // Calculate statistics
        final totalSuppliers = suppliers.length;
        final totalPayments = suppliers.fold<double>(0,
            (sum, supplier) => sum + (supplier["totalPayments"] as num? ?? 0));
        final totalDebts = suppliers.fold<double>(
            0, (sum, supplier) => sum + (supplier["totalDebts"] as num? ?? 0));
        final highDebtSuppliers = suppliers
            .where((supplier) => (supplier["totalDebts"] as num? ?? 0) > 5000)
            .length;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'analytics',
                    color: colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Supplier Statistics',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: 'business',
                      label: 'Total Suppliers',
                      value: totalSuppliers.toString(),
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: 'account_balance_wallet',
                      label: 'Total Payments',
                      value: '\$${totalPayments.toStringAsFixed(0)}',
                      color: colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: 'credit_card',
                      label: 'Total Debts',
                      value: '\$${totalDebts.toStringAsFixed(0)}',
                      color: colorScheme.error,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: 'warning',
                      label: 'High Debt',
                      value: highDebtSuppliers.toString(),
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
