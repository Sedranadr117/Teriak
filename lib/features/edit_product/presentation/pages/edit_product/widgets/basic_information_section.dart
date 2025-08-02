import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/text_field_block.dart';


class BasicInformationSection extends StatelessWidget {
  final TextEditingController arabicTradeNameController;
  final TextEditingController englishTradeNameController;
    final TextEditingController arabicScientificNameController;
  final TextEditingController englishScientificNameController;
  final bool isExpanded;
  final VoidCallback onToggle;

  const BasicInformationSection({
    super.key,
    required this.arabicTradeNameController,
    required this.englishTradeNameController,
        required this.arabicScientificNameController,
    required this.englishScientificNameController,
    this.isExpanded = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.w * 0.04,
        vertical: context.h * 0.02,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(context.w * 0.05),
        border: Border(
          left: BorderSide(
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
            width: 4.0,
          ),
        ),
        boxShadow:  [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, context.h * 0.005),
          ),
        ]
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.all(context.w * 0.04),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color:
                        isDark ? AppColors.primaryDark : AppColors.primaryLight,
                    size: context.w * 0.06,
                  ),
                  SizedBox(width: context.w * 0.03),
                  Expanded(
                    child: Text(
                      'Basic Info'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.onSurface,
                    size: context.w * 0.06,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: context.h * 0.005,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.all(context.w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldBlock(
                    label: 'Trade Product Name ar'.tr,
                    isRequired: true,
                    controller: arabicTradeNameController,
                    //errorText: null,
                    hintText: 'Enter Tr Product Name ar'.tr,
                    iconName: 'language',
                    onChanged: () {},
                  ),
                  SizedBox(height: context.h * 0.02),
                  TextFieldBlock(
                    label: 'Trade Product Name en'.tr,
                    isRequired: true,
                    controller: englishTradeNameController,
                    //errorText: null,
                    hintText: 'Enter Tr Product Name en'.tr,
                    iconName: 'translate',
                    onChanged: () {},
                  ),
                  SizedBox(height: context.h * 0.02),
                  TextFieldBlock(
                    label: 'Sc Product Name ar'.tr,
                    isRequired: false,
                    controller: arabicScientificNameController,
                    //errorText: null,
                    hintText: 'Enter Sc Product Name ar'.tr,
                    iconName: 'language',
                    onChanged: (){},
                  ),
                  SizedBox(height: context.h * 0.02),
                  TextFieldBlock(
                    label: 'Sc Product Name en'.tr,
                    isRequired: false,
                    controller: englishScientificNameController,
                    //errorText: null,
                    hintText: 'Enter Sc Product Name en'.tr,
                    iconName: 'translate',
                    onChanged: (){},
                  ),
                  SizedBox(height: context.h * 0.02),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
