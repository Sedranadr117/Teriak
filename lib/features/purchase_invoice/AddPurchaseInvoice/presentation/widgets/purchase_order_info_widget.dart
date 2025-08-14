import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';

class PurchaseOrderInfoWidget extends StatelessWidget {
  final PurchaseOrderModel purchaseOrder;

  const PurchaseOrderInfoWidget({
    super.key,
    required this.purchaseOrder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'بيانات طلب الشراء',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                  Text(
                purchaseOrder.supplierName,
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                purchaseOrder.currency,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
          
            ],
          ),
        ],
      ),
    );
  }
}
