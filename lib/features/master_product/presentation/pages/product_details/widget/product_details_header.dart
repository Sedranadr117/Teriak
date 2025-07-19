import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

import 'package:teriak/features/master_product/presentation/pages/product_details/subwidget/infro_details_column_widget.dart';

class ProductDetailsHeader extends StatefulWidget {
  final Map<String, dynamic> drugData;

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
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.warningDark
                  : AppColors.warningLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.warningDark
                    : AppColors.warningLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: widget.drugData['prescriptionRequired']
                      ? 'lock'
                      : 'lock_open',
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.warningDark
                      : AppColors.warningLight,
                  size: 16,
                ),
                //SizedBox(width: context.w * 0.01),
                Text(
                  widget.drugData['prescriptionRequired']
                      ? 'Prescription Required'.tr
                      : 'No Prescription'.tr,
                  style: TextStyle(
                    fontSize: context.h * 0.011,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.warningDark
                        : AppColors.warningLight,
                  ),
                ),
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
                widget.drugData["tradeName"] as String? ?? "N/A",
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
                      widget.drugData["scientificName"] as String? ?? "N/A",
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
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                InfoDetailsColumnWidget(
                  iconName: 'inventory',
                  labelName: "Quantity".tr,
                  value: widget.drugData["drugQuantity"] as String? ?? "N/A",
                ),
                space(context),
                InfoDetailsColumnWidget(
                    iconName: 'medication',
                    labelName: "Dosage".tr,
                    value:
                        "${widget.drugData["dosageSize"] as String? ?? "N/A"}${widget.drugData["dosageUnit"] as String? ?? ""}"),
                space(context),
                InfoDetailsColumnWidget(
                  iconName: 'category',
                  labelName: "Form".tr,
                  value: widget.drugData["drugForm"] as String? ?? "N/A",
                ),
                space(context),
                InfoDetailsColumnWidget(
                  iconName: 'local_pharmacy',
                  labelName: "Source".tr,
                  value: widget.drugData["productSource"] as String? ?? "N/A",
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
