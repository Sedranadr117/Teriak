import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class InvoiceSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Map<String, dynamic> originalInvoice;
  final VoidCallback onSaveChanges;
  final bool hasChanges;

  const InvoiceSummaryWidget({
    super.key,
    required this.products,
    required this.originalInvoice,
    required this.onSaveChanges,
    required this.hasChanges,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalAmount = _calculateTotalAmount();
    final originalAmount = originalInvoice['totalAmount'] as double? ?? 0.0;
    final amountDifference = totalAmount - originalAmount;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'receipt_long',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Invoice Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Summary Details
            _buildSummaryRow(
              context,
              'Total Products',
              '${products.length} items',
              null,
            ),
            SizedBox(height: 1.h),

            _buildSummaryRow(
              context,
              'Total Received Quantity',
              '${_getTotalReceivedQuantity()} units',
              null,
            ),
            SizedBox(height: 1.h),

            _buildSummaryRow(
              context,
              'Total Bonus Quantity',
              '${_getTotalBonusQuantity()} units',
              Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(height: 2.h),

            const Divider(),
            SizedBox(height: 2.h),

            // Amount Comparison
            if (hasChanges) ...[
              _buildSummaryRow(
                context,
                'Original Amount',
                '\$${originalAmount.toStringAsFixed(2)}',
                theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: 1.h),
              _buildSummaryRow(
                context,
                'New Amount',
                '\$${totalAmount.toStringAsFixed(2)}',
                theme.colorScheme.primary,
              ),
              SizedBox(height: 1.h),
              _buildSummaryRow(
                context,
                'Difference',
                '${amountDifference >= 0 ? '+' : ''}\$${amountDifference.toStringAsFixed(2)}',
                amountDifference >= 0
                    ? Theme.of(context).colorScheme.secondary
                    : theme.colorScheme.error,
              ),
              SizedBox(height: 2.h),
              const Divider(),
              SizedBox(height: 2.h),
            ],

            // Final Total
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Changes Indicator
            if (hasChanges) ...[
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Unsaved Changes',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          Text(
                            'You have modified this invoice. Save changes to update the record.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 4.h),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hasChanges ? onSaveChanges : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  backgroundColor: hasChanges
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  foregroundColor: hasChanges
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: hasChanges ? 'save' : 'check_circle',
                      color: hasChanges
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      hasChanges ? 'Save Changes' : 'No Changes to Save',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    Color? valueColor,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  double _calculateTotalAmount() {
    return products.fold(0.0, (total, product) {
      final receivedQty = product['receivedQuantity'] as int? ?? 0;
      final bonusQty = product['bonusQuantity'] as int? ?? 0;
      final actualPrice = product['actualPrice'] as double? ??
          (product['unitPrice'] as double? ?? 0.0);

      return total + ((receivedQty + bonusQty) * actualPrice);
    });
  }

  int _getTotalReceivedQuantity() {
    return products.fold(0, (total, product) {
      return total + (product['receivedQuantity'] as int? ?? 0);
    });
  }

  int _getTotalBonusQuantity() {
    return products.fold(0, (total, product) {
      return total + (product['bonusQuantity'] as int? ?? 0);
    });
  }
}
