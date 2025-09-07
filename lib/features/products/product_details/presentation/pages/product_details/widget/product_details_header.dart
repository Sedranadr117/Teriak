import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/extensions/string.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';

import 'package:teriak/features/products/product_details/presentation/pages/product_details/subWidget/infro_details_column_widget.dart';

class ProductDetailsHeader extends StatefulWidget {
  final ProductEntity drugData;

  const ProductDetailsHeader({
    super.key,
    required this.drugData,
  });

  @override
  State<ProductDetailsHeader> createState() => _ProductDetailsHeaderState();
}

class _ProductDetailsHeaderState extends State<ProductDetailsHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(context.w * 0.04),
      padding: EdgeInsets.all(context.w * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.shadowDark
                : AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: context.w * 0.03, vertical: context.w * 0.01),
            decoration: BoxDecoration(
              color: widget.drugData.requiresPrescription
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.warningDark.withValues(alpha: 0.1)
                      : AppColors.warningLight.withValues(alpha: 0.1))
                  : (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.successDark.withValues(alpha: 0.1)
                      : AppColors.successLight.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.drugData.requiresPrescription
                    ? (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.warningDark
                        : AppColors.warningLight)
                    : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.successDark
                        : AppColors.successLight),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: widget.drugData.requiresPrescription
                      ? 'lock'
                      : 'lock_open',
                  color: widget.drugData.requiresPrescription
                                ? (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.warningDark
                                    : AppColors.warningLight)
                                : (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.successDark
                                    : AppColors.successLight),
                  size: 16,
                ),
                //SizedBox(width: context.w * 0.01),
                Text(
                    widget.drugData.requiresPrescription
                        ? 'Prescription Required'.tr
                        : 'No Prescription'.tr,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: widget.drugData.requiresPrescription
                                        ? (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.warningDark
                                            : AppColors.warningLight)
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColors.successDark
                                            : AppColors.successLight),
                                    fontWeight: FontWeight.w500,
                       
                        )),
              ],
            ),
          ),

          SizedBox(height: context.w * 0.03),

          // Product Names
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trade Name
              Text(
                widget.drugData.tradeName as String? ?? "N/A",
                style: TextStyle(
                  fontSize: context.h * 0.025,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.onSurfaceDark
                      : AppColors.onSurfaceLight,
                ),
              ),

              SizedBox(height: context.w * 0.02),

              // Scientific Name
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'science',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.primaryDark
                        : AppColors.primaryLight,
                    size: 16,
                  ),
                  SizedBox(width: context.w * 0.02),
                  Expanded(
                    child: Text(
                      widget.drugData.scientificName as String? ??" " ,
                      style: TextStyle(
                        fontSize: context.h * 0.018,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.onSurfaceDark
                            : AppColors.onSurfaceLight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: context.w * 0.04),
          Container(
            padding: EdgeInsets.all(context.w * 0.03),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark
                  : AppColors.surfaceLight,
              //borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                InfoDetailsColumnWidget(
                  iconName: 'inventory',
                  labelName: "Quantity".tr,
                  value: widget.drugData.size as String? ?? "N/A",
                ),
                space(context),
                if (!(widget.drugData.concentration ).isNullOrEmpty())
                InfoDetailsColumnWidget(
                    iconName: 'medication',
                    labelName: "Dosage".tr,
                    value: widget.drugData.concentration as String? ?? "N/A"),
                space(context),
                InfoDetailsColumnWidget(
                  iconName: 'category',
                  labelName: "Form".tr,
                  value: widget.drugData.form as String? ?? "N/A",
                ),
                space(context),
                InfoDetailsColumnWidget(
                  iconName: 'local_pharmacy',
                  labelName: "Source".tr,
                  value: widget.drugData.productType as String? ?? "N/A",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget space(BuildContext context) {
  return Container(
    height: context.h * 0.08,
    width: 1,
    color: Theme.of(context).colorScheme.outline,
  );
}
