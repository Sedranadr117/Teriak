import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/controller/add_purchase_order_controller.dart';

class OrderItemsList extends StatelessWidget {
  final RxList<PurchaseOrderItem> items;
  final String currency;
  final Function(int, {int? quantity, double? price}) onUpdateItem;
  final Function(int) onRemoveItem;

  const OrderItemsList({
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
                return _buildEmptyState();
              }
              return _buildItemsList();
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

  Widget _buildEmptyState() {
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
          SizedBox(height: 0.4.h),
          Text(
            'Add your first product to get started'.tr,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildOrderItem(item, index);
      }).toList(),
    );
  }

  Widget _buildOrderItem(PurchaseOrderItem item, int index) {
    return Builder(builder: (context) {
      return Container(
        margin: EdgeInsets.only(bottom: 1.2.h),
        padding: EdgeInsets.all(2.5.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderLight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemHeader(item, index),
            SizedBox(height: 0.8.h),
            _buildItemDetails(item, index),
            SizedBox(height: 0.8.h),
            _buildItemTotal(item),
          ],
        ),
      );
    });
  }

  Widget _buildItemHeader(PurchaseOrderItem item, int index) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.tradeName ?? 'Unknown Product'.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              if (item.product.scientificName != null &&
                  item.product.scientificName!.isNotEmpty) ...[
                SizedBox(height: 0.3.h),
                Text(
                  item.product.scientificName ?? '',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          onPressed: () => onRemoveItem(index),
          icon: Icon(
            Icons.delete_outline,
            color: AppColors.errorLight,
            size: 5.w,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.errorLight.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            minimumSize: Size(8.w, 4.h),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildItemDetails(PurchaseOrderItem item, int index) {
    return Row(
      children: [
        Expanded(
          child: _buildQuantityField(item, index),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildPriceField(item, index),
        ),
      ],
    );
  }

  Widget _buildQuantityField(PurchaseOrderItem item, int index) {
    final quantityController =
        TextEditingController(text: item.quantity.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity'.tr,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondaryLight,
          ),
        ),
        SizedBox(height: 0.4.h),
        TextFormField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 2.w,
              vertical: 0.8.h,
            ),
            isDense: true,
          ),
          style: TextStyle(fontSize: 10.sp),
          onChanged: (value) {
            final quantity = int.tryParse(value);
            if (quantity != null && quantity > 0) {
              onUpdateItem(index, quantity: quantity);
            }
          },
        ),
      ],
    );
  }

  Widget _buildPriceField(PurchaseOrderItem item, int index) {
    final priceController =
        TextEditingController(text: item.price.toStringAsFixed(2));

    final isMasterProduct = item.product.productType != null &&
        (item.product.productType == "Master" ||
            item.product.productType == "مركزي");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit Price'.tr,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondaryLight,
          ),
        ),
        SizedBox(height: 0.4.h),
        TextFormField(
          controller: priceController,
          keyboardType: TextInputType.number,
          enabled: !isMasterProduct,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.borderLight),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 2.w,
              vertical: 0.8.h,
            ),
            isDense: true,
          ),
          style: TextStyle(fontSize: 10.sp),
          onChanged: (value) {
            if (isMasterProduct) return;
            final price = double.tryParse(value);
            if (price != null && price > 0) {
              onUpdateItem(index, price: price);
            }
          },
        ),
      ],
    );
  }

  Widget _buildItemTotal(PurchaseOrderItem item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 0.8.h,
        horizontal: 2.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Line Total'.tr,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryLight,
            ),
          ),
          Text(
            '${item.total.toStringAsFixed(2)} $currency',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
