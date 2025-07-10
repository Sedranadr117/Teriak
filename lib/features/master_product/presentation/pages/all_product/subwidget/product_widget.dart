import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/subwidget/box_in_product_widget.dart';

class ProductWidget extends StatelessWidget {
  final Map<String, dynamic> drug;
  final VoidCallback onTap;

  const ProductWidget({
    super.key,
    required this.drug,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool prescriptionRequired =
        drug['prescriptionRequired'] as bool? ?? false;
    final String productSource = drug['productSource'] as String? ?? '';
    final String tradeName = drug['tradeName'] as String? ?? '';
    final String scientificName = drug['scientificName'] as String? ?? '';
    final String dosageSize = drug['dosageSize']?.toString() ?? '';
    final String dosageUnit = drug['dosageUnit'] ?? '';
    final String drugForm = drug['drugForm'] ?? '';
    final String drugQuantity = drug['drugQuantity'] ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: productSource == "Central"
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              width: 4.0,
            ),
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(context.w * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tradeName,
                          style: Theme.of(context).textTheme.titleMedium
                          /*?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryLight,
                              ),*/
                          ,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.h * 0.01),
                        Text(
                          scientificName,
                          style: Theme.of(context).textTheme.bodyMedium
                          /*?.copyWith(
                                color: AppColors.textSecondaryLight,
                              ),*/
                          ,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.w * 0.02,
                        vertical: context.h * 0.005),
                    decoration: BoxDecoration(
                      color: productSource == 'Central'
                          ? AppColors.primaryLight
                          : AppColors.primaryVariantLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      productSource,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: productSource == 'Central'
                                ? AppColors.primaryLight
                                : AppColors.primaryVariantLight,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h * 0.02),
              Row(
                children: [
                  Expanded(
                    child: BoxInProductWidget(
                      icon: 'inventory',
                      label: 'Quantity'.tr,
                      value: drugQuantity,
                    ),
                  ),
                  SizedBox(width: context.w * 0.02),
                  Expanded(
                    child: BoxInProductWidget(
                      icon: 'fitness_center',
                      label: 'Dosage'.tr,
                      value: '$dosageSize$dosageUnit',
                    ),
                  ),
                  SizedBox(width: context.w * 0.02),
                  Expanded(
                    child: BoxInProductWidget(
                      icon: 'category',
                      label: 'Form'.tr,
                      value: drugForm,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.w * 0.03,
                        vertical: context.h * 0.01),
                    decoration: BoxDecoration(
                      color: prescriptionRequired
                          ? AppColors.warningLight
                          : AppColors.successLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: prescriptionRequired
                            ? AppColors.warningLight
                            : AppColors.successLight,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: prescriptionRequired ? 'lock' : 'lock_open',
                          color: prescriptionRequired
                              ? AppColors.warningLight
                              : AppColors.successLight,
                          size: 16,
                        ),
                        SizedBox(width: context.w * 0.01),
                        Text(
                          prescriptionRequired
                              ? 'Prescription Required'.tr
                              : 'No Prescription'.tr,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: prescriptionRequired
                                        ? AppColors.warningLight
                                        : AppColors.successLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppColors.textSecondaryLight,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
