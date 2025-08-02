import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class InvoiceTotalCard extends StatelessWidget {
  final double subtotal;
  final double discountAmount;
  final double total;
  final TextEditingController discountController;
  final String discountType;
  final Function(String) onDiscountTypeChanged;
  final VoidCallback onApplyDiscount;

  const InvoiceTotalCard({
    Key? key,
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    required this.discountController,
    required this.discountType,
    required this.onDiscountTypeChanged,
    required this.onApplyDiscount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calculate',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Invoice Summary'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),

            SizedBox(height: 4.w),

            // Subtotal
            _buildSummaryRow(
              context,
              'Subtotal'.tr,
              '\$${subtotal.toStringAsFixed(2)}',
              isSubtotal: true,
            ),

            SizedBox(height: 3.w),

            // Discount Section
            _buildDiscountSection(context),

            SizedBox(height: 3.w),

            Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.outline.withAlpha(77),
            ),

            SizedBox(height: 3.w),

            // Total
            _buildSummaryRow(
              context,
              'Total'.tr,
              '\$${total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String amount,
      {bool isSubtotal = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                fontSize: isTotal ? 16.sp : null,
              ),
        ),
        Text(
          amount,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
                fontSize: isTotal ? 16.sp : null,
                color: isTotal
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  Widget _buildDiscountSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(77),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'discount',
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Apply Discount'.tr,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              // Discount Type Toggle
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withAlpha(77),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDiscountTypeButton(
                      context,
                      'percentage',
                      '%',
                      discountType == 'percentage',
                    ),
                    _buildDiscountTypeButton(
                      context,
                      'fixed',
                      '\$',
                      discountType == 'fixed',
                    ),
                  ],
                ),
              ),

              SizedBox(width: 3.w),

              // Discount Input
              Expanded(
                child: TextFormField(
                  controller: discountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    hintText: discountType == 'percentage'
                        ? 'Enter %'.tr
                        : 'Enter amount'.tr,
                    suffixText: discountType == 'percentage' ? '%' : '\$',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                  ),
                  onChanged: (value) => onApplyDiscount(),
                ),
              ),

              SizedBox(width: 3.w),

              // Apply Button
              ElevatedButton(
                onPressed: onApplyDiscount,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                  minimumSize: Size(0, 0),
                ),
                child: Text(
                  'Apply'.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.backgroundColor),
                ),
              ),
            ],
          ),
          if (discountAmount > 0) ...[
            SizedBox(height: 3.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppColors.successLight,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Discount Applied'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.successLight,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                Text(
                  '-\$${discountAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.successLight,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDiscountTypeButton(
      BuildContext context, String type, String symbol, bool isSelected) {
    return InkWell(
      onTap: () => onDiscountTypeChanged(type),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          symbol,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
