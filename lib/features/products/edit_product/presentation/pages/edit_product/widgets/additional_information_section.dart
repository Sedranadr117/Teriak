import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/products/add_product/presentation/pages/add_product/subWidget/drop_down_block.dart';
import 'package:teriak/features/products/add_product/presentation/pages/add_product/subWidget/switch_card.dart';
import 'package:teriak/features/products/add_product/presentation/pages/add_product/subWidget/text_field_block.dart';

class AdditionalInformationSection extends StatelessWidget {
  final TextEditingController dosageController;
  final TextEditingController notesController;
  //final TextEditingController minStockController;
  final TextEditingController quantityController;

  final String? selectedProductType;
  final String? selectedClassification;
  final String? selectedForm;
  final String? selectedManufacturer;
  final bool requiresPrescription;

  final VoidCallback onFormTap;
  final VoidCallback onManufacturerTap;
  final VoidCallback onProductTypeTap;
  final VoidCallback onClassificationTap;
  final Function(bool) onPrescriptionChanged;
  final bool isExpanded;
  final VoidCallback onToggle;

  const AdditionalInformationSection({
    super.key,
    required this.dosageController,
    required this.notesController,
    //required this.minStockController,
    required this.quantityController,
    this.selectedProductType,
    this.selectedClassification,
    this.selectedForm,
    this.selectedManufacturer,
    required this.requiresPrescription,
    required this.onFormTap,
    required this.onManufacturerTap,
    required this.onProductTypeTap,
    required this.onClassificationTap,
    required this.onPrescriptionChanged,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.w * 0.04,
        vertical: context.h * 0.02,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(context.w * 0.05),
        border: Border(
          left: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 4.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
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
                    iconName: 'inventory_2',
                    color: Theme.of(context).colorScheme.primary,
                    size: context.w * 0.06,
                  ),
                  SizedBox(width: context.w * 0.03),
                  Expanded(
                    child: Text(
                      'Add info'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
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
              color: Colors.grey.withAlpha(50),
            ),
            Padding(
              padding: EdgeInsets.all(context.w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prescription Switch
                  SwitchCard(
                    value: requiresPrescription,
                    onChanged: onPrescriptionChanged,
                  ),
                  SizedBox(height: context.h * 0.03),
                  DropDownBlock(
                      label: 'Form'.tr,
                      iconName: 'medication',
                      isRequired: true,
                      value: selectedForm ?? 'Select Form'.tr,
                      onTap: onFormTap),
                  SizedBox(height: context.h * 0.02),
                  DropDownBlock(
                      label: 'Manufacturer'.tr,
                      iconName: 'business',
                      isRequired: true,
                      value: selectedManufacturer ?? 'Select Manufacturer'.tr,
                      onTap: onManufacturerTap),
                  SizedBox(height: context.h * 0.02),
                  TextFieldBlock(
                      label: 'Quantity'.tr,
                      isRequired: true,
                      controller: quantityController,
                      //errorText: null,
                      hintText: 'MS ex'.tr,
                      iconName: 'countertops',
                      onChanged: () {}),

                  SizedBox(height: context.h * 0.02),
                  DropDownBlock(
                    label: 'Product Type'.tr,
                    isRequired: false,
                    iconName: 'category',
                    value: selectedProductType,
                    onTap: onProductTypeTap,
                  ),
                  SizedBox(height: context.h * 0.02),
                  DropDownBlock(
                    label: 'Pharmacological classification'.tr,
                    isRequired: false,
                    iconName: 'local_pharmacy',
                    value: selectedClassification,
                    onTap: onClassificationTap,
                  ),
                  SizedBox(height: context.h * 0.02),
                  TextFieldBlock(
                      label: 'Dosage'.tr,
                      isRequired: false,
                      controller: dosageController,
                      //errorText: null,
                      hintText: 'Dosage ex'.tr,
                      iconName: 'straighten',
                      onChanged: () {}),
                  // SizedBox(height: context.h * 0.02),
                  // TextFieldBlock(
                  //   label: 'Minimum stock'.tr,
                  //   isRequired: false,
                  //   controller: minStockController,
                  //   errorText: null,
                  //   hintText: 'MS ex'.tr,
                  //   iconName: 'inventory',
                  //   onChanged: () {},
                  // ),
                  SizedBox(height: context.h * 0.02),
                  TextFieldBlock(
                    label: 'Medical Notes'.tr,
                    isRequired: false,
                    controller: notesController,
                    //errorText: null,
                    hintText: ' ...',
                    iconName: 'note',
                    onChanged: () {},
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
