import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/pages/widgets/unified_card.dart';
import 'package:teriak/features/purchase_order/edit_purchase_order/presentation/controller/edit_purchase_order_controller.dart';

class EditOrderItemsList extends StatelessWidget {
  final RxList<EditPurchaseOrderItem> items;
  final String currency;
  final Function(int, {int? quantity, double? price}) onUpdateItem;
  final Function(int) onRemoveItem;

  EditOrderItemsList({
    super.key,
    required this.items,
    required this.currency,
    required this.onUpdateItem,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 1.2.h),
            Obx(() {
              if (items.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildItemsList(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Row(
        children: [
          Icon(
            Icons.list_alt,
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
            size: 5.w,
          ),
          SizedBox(width: 1.w),
          Text(
            'Products List'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:
                      isDark ? AppColors.primaryDark : AppColors.primaryLight,
                ),
          ),
          const Spacer(),
          Obx(() => Text(
                '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textSecondaryLight,
                ),
              )),
        ],
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 12.w,
            color: AppColors.textSecondaryLight,
          ),
          SizedBox(height: 1.2.h),
          Text(
            'No products added yet'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Add products to your order'.tr,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.h),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(context, item, index);
      },
    );
  }

  Widget _buildItemCard(
      BuildContext context, EditPurchaseOrderItem item, int index) {
    bool _isPharmacyProduct() {
      final productType = item.productType;
      return productType == "PHARMACY" || productType == "صيدلية";
    }

    // Helper method to check if product type is master
    bool _isMasterProduct() {
      final productType = item.productType;
      return productType == "MASTER" || productType == "مركزي";
    }

    final bool isPriceEditable = _isPharmacyProduct();
    final bool isMaster = _isMasterProduct();
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.tradeName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (item.product.scientificName.isNotEmpty)
                      Text(
                        item.product.scientificName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onRemoveItem(index),
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Quantity and Price Controls
          Row(
            children: [
              // Quantity
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity'.tr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (item.quantity > 1) {
                              onUpdateItem(index, quantity: item.quantity - 1);
                            }
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          child: Text(
                            '${item.quantity}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onUpdateItem(index, quantity: item.quantity + 1);
                          },
                          icon: Icon(
                            Icons.add_circle_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 2.w),

              // Price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price'.tr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    TextFormField(
                      initialValue: item.price.toString(),

                      keyboardType: TextInputType.number,
                      readOnly:
                          !isPriceEditable, // Can edit only if pharmacy product
                      decoration: InputDecoration(
                        suffixText: currency == 'USD' ? '\$' : 'ل.س',
                        hintText: '0.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.borderLight,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        suffixIcon: !isPriceEditable
                            ? Icon(
                                Icons.lock,
                                color: AppColors.textSecondaryLight,
                                size: 4.w,
                              )
                            : null,
                        filled: !isPriceEditable,
                        fillColor: !isPriceEditable
                            ? AppColors.borderLight.withOpacity(0.1)
                            : null,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: !isPriceEditable
                            ? AppColors.textSecondaryLight
                            : AppColors.textSecondaryLight,
                      ),
                      onChanged: (value) {
                        final price = double.tryParse(value);
                        if (price != null && price >= 0) {
                          onUpdateItem(index, price: price);
                        }
                      },
                    ),
                    if (!isPriceEditable) ...[
                      SizedBox(height: 0.4.h),
                      Text(
                        isMaster
                            ? 'Price is fixed for master products'.tr
                            : 'Price is readonly for this product type'.tr,
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 8.sp,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Total
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${currency == 'USD' ? '\$' : 'ل.س'}${item.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
