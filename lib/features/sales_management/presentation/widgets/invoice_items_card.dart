import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/core/params/params.dart';

class InvoiceItemsCard extends StatelessWidget {
  final List<InvoiceItem> items;
  final Function(int itemId, int newQuantity) onQuantityChanged;

  const InvoiceItemsCard({
    super.key,
    required this.items,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'shopping_cart',
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Invoice Items'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.w),
            if (items.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withAlpha(77),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'shopping_cart_outlined',
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 2.w),
                    Text(
                      'No items added'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(height: 1.w),
                    Text(
                      'Add products to start building the invoice'.tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...items.map((item) => _buildInvoiceItemTile(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceItemTile(BuildContext context, InvoiceItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(77),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: item.isPrescription
                ? AppColors.warningLight.withAlpha(26)
                : AppColors.successLight.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: item.isPrescription ? 'medical_services' : 'medication',
            color: item.isPrescription
                ? AppColors.warningLight
                : AppColors.successLight,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.w),
                  Text(
                    item.isPrescription
                        ? 'Prescription Required'.tr
                        : 'Over-the-Counter'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: item.isPrescription
                              ? AppColors.warningLight
                              : AppColors.successLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${item.total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 1.w),
          child: Text(
            '${item.quantity} × \$${item.unitPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Divider(
                color: Theme.of(context).colorScheme.outline.withAlpha(77),
              ),
              SizedBox(height: 3.w),
              Row(
                children: [
                  Text(
                    'Quantity:'.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Spacer(),
                  _buildQuantityControls(context, item),
                ],
              ),
              SizedBox(height: 3.w),
              Row(
                children: [
                  Text(
                    'Unit Price:'.tr,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Spacer(),
                  Text(
                    '\$${item.unitPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 3.w),
              Row(
                children: [
                  Text(
                    'Line Total:'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Spacer(),
                  Text(
                    '\$${item.total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, InvoiceItem item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(77),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            context,
            icon: 'remove',
            onTap: () => onQuantityChanged(item.id, item.quantity - 1),
            enabled: true,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            child: Text(
              '${item.quantity}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          _buildQuantityButton(
            context,
            icon: 'add',
            onTap: () => onQuantityChanged(item.id, item.quantity + 1),
            enabled: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(
    BuildContext context, {
    required String icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.all(2.w),
        child: CustomIconWidget(
          iconName: icon,
          size: 16,
          color: enabled
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(128),
        ),
      ),
    );
  }
}

class InvoiceItem {
  final int id;
  final String name;
  final int quantity;
  final double unitPrice;
  final bool isPrescription;

  InvoiceItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.isPrescription,
  });

  double get total => quantity * unitPrice;

  InvoiceItem copyWith({
    int? id,
    String? name,
    int? quantity,
    double? unitPrice,
    bool? isPrescription,
  }) {
    return InvoiceItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      isPrescription: isPrescription ?? this.isPrescription,
    );
  }

  /// ✅ تحويل InvoiceItem إلى SaleItemParams
  SaleItemParams toSaleItemParams() {
    return SaleItemParams(
      stockItemId: id,
      quantity: quantity,
      unitPrice: unitPrice,
      discountType: "FIXED_AMOUNT", // أو dynamic إذا عندك أنواع خصم
      discountValue: 0.0, // مبدئياً بدون خصم
    );
  }
}
