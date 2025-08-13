import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class RunningTotalWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final double totalAmount;

  const RunningTotalWidget({
    super.key,
    required this.products,
    required this.totalAmount,
  });

  int get _totalReceivedItems {
    return products.fold(
        0, (sum, product) => sum + (product['receivedQuantity'] as int));
  }

  int get _totalBonusItems {
    return products.fold(
        0, (sum, product) => sum + (product['bonusQuantity'] as int));
  }

  double get _subtotal {
    return totalAmount;
  }

  double get _taxAmount {
    // Assuming 15% VAT/Tax
    return _subtotal * 0.15;
  }

  double get _finalTotal {
    return _subtotal + _taxAmount;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.05),
            theme.colorScheme.tertiary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'ملخص الفاتورة',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Quick Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'العناصر المستلمة',
                  _totalReceivedItems.toString(),
                  'inventory_2',
                  theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  'العناصر المجانية',
                  _totalBonusItems.toString(),
                  'redeem',
                  theme.colorScheme.tertiary,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  'إجمالي العناصر',
                  (_totalReceivedItems + _totalBonusItems).toString(),
                  'widgets',
                  theme.colorScheme.secondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Calculation Breakdown
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                _buildCalculationRow(
                  context,
                  'المجموع الفرعي',
                  _subtotal,
                  false,
                ),
                SizedBox(height: 1.h),
                _buildCalculationRow(
                  context,
                  'ضريبة القيمة المضافة (15%)',
                  _taxAmount,
                  false,
                ),
                SizedBox(height: 1.h),
                Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  thickness: 1,
                ),
                SizedBox(height: 1.h),
                _buildCalculationRow(
                  context,
                  'المبلغ الإجمالي المدفوع للمورد',
                  _finalTotal,
                  true,
                ),
              ],
            ),
          ),

          // Payment Method Info (Optional)
          if (_finalTotal > 0) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'سيتم تحديد طريقة الدفع في الخطوة التالية',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationRow(
    BuildContext context,
    String label,
    double amount,
    bool isTotal,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
        ),
        Text(
          '\$${NumberFormat('#,##0.00').format(amount)}',
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
        ),
      ],
    );
  }
}
