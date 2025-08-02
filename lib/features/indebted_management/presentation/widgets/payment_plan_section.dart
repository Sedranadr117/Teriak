import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PaymentPlanSection extends StatelessWidget {
  final bool enablePaymentPlan;
  final int installments;
  final double installmentAmount;
  final double totalDebt;
  final Function(bool) onEnablePaymentPlanChanged;
  final Function(int) onInstallmentsChanged;

  const PaymentPlanSection({
    super.key,
    required this.enablePaymentPlan,
    required this.installments,
    required this.installmentAmount,
    required this.totalDebt,
    required this.onEnablePaymentPlanChanged,
    required this.onInstallmentsChanged,
    required paymentPlan,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Payment plans help customers manage their debts by breaking them into smaller, manageable installments.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),
        SwitchListTile(
          title: Text(
            'Enable Payment Plan',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            'Allow customer to pay in installments',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          value: enablePaymentPlan,
          onChanged: onEnablePaymentPlanChanged,
          activeColor: colorScheme.primary,
        ),
        if (enablePaymentPlan) ...[
          SizedBox(height: 2.h),
          Text(
            'Number of Installments',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [2, 3, 4, 6].map((count) {
              final isSelected = installments == count;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: count == 6 ? 0 : 2.w),
                  child: OutlinedButton(
                    onPressed: () => onInstallmentsChanged(count),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      side: BorderSide(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '$count months',
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 3.h),
          Container(
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Breakdown',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildBreakdownRow(
                    'Total Debt:', '\$${totalDebt.toStringAsFixed(2)}'),
                _buildBreakdownRow('Number of Payments:', '$installments'),
                _buildBreakdownRow('Amount per Payment:',
                    '\$${installmentAmount.toStringAsFixed(2)}'),
                Divider(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  height: 3.h,
                ),
                _buildBreakdownRow(
                  'First Payment Due:',
                  '${DateTime.now().add(Duration(days: 30)).day}/${DateTime.now().add(Duration(days: 30)).month}/${DateTime.now().add(Duration(days: 30)).year}',
                ),
                _buildBreakdownRow(
                  'Final Payment Due:',
                  '${DateTime.now().add(Duration(days: 30 * installments)).day}/${DateTime.now().add(Duration(days: 30 * installments)).month}/${DateTime.now().add(Duration(days: 30 * installments)).year}',
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.orange,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Payment plan can be modified later if needed.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
