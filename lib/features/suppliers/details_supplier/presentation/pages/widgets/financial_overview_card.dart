import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/themes/app_theme.dart';


class FinancialOverviewCard extends StatelessWidget {
  final Map<String, dynamic> supplier;

  const FinancialOverviewCard({
    super.key,
    required this.supplier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalPayments = supplier["totalPayments"] as double;
    final totalDebts = supplier["totalDebts"] as double;
    final currency = supplier["preferredCurrency"] as String;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'analytics',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  "Financial Overview",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildFinancialItem(
                    context: context,
                    title: "Total Payments",
                    amount: totalPayments,
                    currency: currency,
                    color: Theme.of(context).colorScheme.tertiary,
                    icon: 'trending_up',
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildFinancialItem(
                    context: context,
                    title: "Total Debts",
                    amount: totalDebts,
                    currency: currency,
                    color: totalDebts > 0
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                    icon: 'trending_down',
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Net Balance",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "${(totalPayments - totalDebts).toStringAsFixed(2)} $currency",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: (totalPayments - totalDebts) >= 0
                          ? Theme.of(context).colorScheme.tertiary
                          : colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialItem({
    required BuildContext context,
    required String title,
    required double amount,
    required String currency,
    required Color color,
    required String icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
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
                size: 18,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            "${amount.toStringAsFixed(2)} $currency",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
