import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class InvoiceSummaryWidget extends StatelessWidget {
  final int totalReceivedItems;
  final int totalBonusItems;
  final double totalAmount;
  final bool isSaving;
  final VoidCallback onProceedToPayment;

  const InvoiceSummaryWidget({
    super.key,
    required this.totalReceivedItems,
    required this.totalBonusItems,
    required this.totalAmount,
    required this.isSaving,
    required this.onProceedToPayment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'ملخص الفاتورة',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Quick Stats Row - Smaller size
          Row(
            children: [
              Expanded(
                child: _buildSmallStatCard(
                  context,
                  'العناصر المستلمة',
                  totalReceivedItems.toString(),
                  'inventory_2',
                  theme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: _buildSmallStatCard(
                  context,
                  'العناصر المجانية',
                  totalBonusItems.toString(),
                  'redeem',
                  theme.colorScheme.tertiary,
                ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: _buildSmallStatCard(
                  context,
                  'إجمالي العناصر',
                  (totalReceivedItems + totalBonusItems).toString(),
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
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildSmallCalculationRow(
                  context,
                  'المجموع الفرعي',
                  totalAmount,
                  false,
                ),
                SizedBox(height: 0.5.h),
                _buildSmallCalculationRow(
                  context,
                  'ضريبة القيمة المضافة (15%)',
                  totalAmount * 0.15,
                  false,
                ),
                SizedBox(height: 0.5.h),
                Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  thickness: 1,
                ),
                SizedBox(height: 0.5.h),
                _buildSmallCalculationRow(
                  context,
                  'المبلغ الإجمالي',
                  totalAmount * 1.15,
                  true,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Continue to Payment Button - Smaller width
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: ElevatedButton(
              onPressed: isSaving ? null : onProceedToPayment,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isSaving
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'payment',
                          color: theme.colorScheme.onPrimary,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'متابعة الدفع',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(
    BuildContext context,
    String title,
    String value,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 16,
          ),
          SizedBox(height: 0.3.h),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCalculationRow(
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
              ? theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
        ),
        Text(
          '\$${NumberFormat('#,##0.00').format(amount)}',
          style: isTotal
              ? theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
        ),
      ],
    );
  }
}
