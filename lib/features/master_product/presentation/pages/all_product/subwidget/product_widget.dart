import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/master_product/domain/entities/product_entity.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/subwidget/box_in_product_widget.dart';

class ProductWidget extends StatelessWidget {
  final ProductEntity drug;
  final VoidCallback onTap;

  const ProductWidget({
    super.key,
    required this.drug,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool prescriptionRequired =
        drug.requiresPrescription as bool? ?? false;
    final String productSource = drug.productType;
    final String tradeName = drug.tradeName as String? ?? '';
    final String scientificName = drug.scientificName as String? ?? '';
    final String dosageSize = drug.concentration as String? ?? '';

    final String drugForm = drug.form as String? ?? '';
    final String drugQuantity = drug.size as String? ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardDark
              : AppColors.cardLight,
          border: Border(
            left: BorderSide(
              color: productSource == "Master"
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primaryDark
                      : AppColors.primaryLight)
                  : (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.secondaryDark
                      : AppColors.secondaryLight),
              width: 4.0,
            ),
          ),
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
                      color: productSource == 'Master'
                          ? (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.primaryDark
                              : AppColors.primaryLight)
                          : (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.primaryVariantDark
                              : AppColors.primaryVariantLight),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(productSource,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall /*?.copyWith(
                            color: productSource == 'Central'
                                ? (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.white)
                                : (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.primaryVariantDark
                                    : AppColors.primaryVariantLight),
                            fontWeight: FontWeight.w500,
                          ),*/
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
                      value:dosageSize,
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
                          ? (Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.warningDark.withValues(alpha: 0.1)
                                  : AppColors.warningLight)
                              .withValues(alpha: 0.1)
                          : (Theme.of(context).brightness == Brightness.dark
                              ? AppColors.successDark.withValues(alpha: 0.1)
                              : AppColors.successLight.withValues(alpha: 0.1)),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: prescriptionRequired
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
                          iconName: prescriptionRequired ? 'lock' : 'lock_open',
                          color: AppColors.textPrimaryLight,
                          size: 16,
                        ),
                        SizedBox(width: context.w * 0.01),
                        Text(
                            prescriptionRequired
                                ? 'Prescription Required'.tr
                                : 'No Prescription'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w500,
                                )),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
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
