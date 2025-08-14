import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/purchase/add_purchase_order/presentation/pages/widgets/unified_card.dart';

class SupplierSelectionCard extends StatelessWidget {
  final List<SupplierModel> suppliers;
  final Function(SupplierModel) onSupplierSelected;
  final SupplierModel? selectedSupplier;
  final String? errorText;

  const SupplierSelectionCard({
    super.key,
    required this.suppliers,
    required this.onSupplierSelected,
    this.selectedSupplier,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return UnifiedCard(
      iconName: 'business',
      title: 'Supplier Selection'.tr,
      children: [
        UnifiedDropdown<SupplierModel>(
          hint: 'Select Supplier'.tr,
          value: selectedSupplier,
          items: suppliers,
          itemText: (supplier) => supplier.name,
          onChanged: (supplier) {
            if (supplier != null) {
              onSupplierSelected(supplier);
            }
          },
          errorText: errorText,
        ),
        if (errorText != null) ...[
          SizedBox(height: 0.8.h),
          UnifiedErrorText(errorText: errorText!),
        ],
        if (selectedSupplier != null) ...[
          SizedBox(height: 1.2.h),
          _buildSupplierDetails(),
        ],
      ],
    );
  }

  Widget _buildSupplierDetails() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                .withValues(alpha:0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                  .withValues(alpha:0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Supplier'.tr + ': ${selectedSupplier!.name}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              SizedBox(height: 0.5.h),
              if (selectedSupplier!.phone.isNotEmpty) ...[
                Text(
                  'Phone'.tr + ': ${selectedSupplier!.phone}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                SizedBox(height: 0.3.h),
              ],
              if (selectedSupplier!.address.isNotEmpty) ...[
                Text(
                  'Address'.tr + ': ${selectedSupplier!.address}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                SizedBox(height: 0.3.h),
              ],
              if (selectedSupplier!.preferredCurrency.isNotEmpty) ...[
                Text(
                  'Currency'.tr + ': ${selectedSupplier!.preferredCurrency}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color:
                        isDark ? AppColors.primaryDark : AppColors.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
