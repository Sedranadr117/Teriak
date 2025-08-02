import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/card_container.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/drop_down_block.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/switch_card.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/text_field_block.dart';

class AdditionalInformationCard extends StatelessWidget {
  final TextEditingController dosageController;
  final TextEditingController notesController;
  //final TextEditingController minStockController;
  final String? selectedProductType;
  final String? selectedClassification;
  final bool requiresPrescription;
  final VoidCallback onProductTypeTap;
  final VoidCallback onClassificationTap;
  final Function(bool) onPrescriptionToggle;
  final VoidCallback onNotesChanged;
  //final VoidCallback onMinStockChanged;
  final VoidCallback onDosageChanged;

  const AdditionalInformationCard({
    super.key,
    required this.dosageController,
    required this.notesController,
    //required this.minStockController,
    required this.selectedProductType,
    required this.selectedClassification,
    required this.requiresPrescription,
    required this.onProductTypeTap,
    required this.onClassificationTap,
    required this.onPrescriptionToggle,
    required this.onDosageChanged,
    required this.onNotesChanged,
    //required this.onMinStockChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      iconName: 'inventory_2',
      labelName: "Add info".tr,
      widgets: [
        SizedBox(height: context.h * 0.03),
        SwitchCard(
          value: requiresPrescription,
          onChanged: onPrescriptionToggle,
        ),
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
            onChanged: onDosageChanged),
        // SizedBox(height: context.h * 0.02),
        // TextFieldBlock(
        //   label: 'Minimum stock'.tr,
        //   isRequired: false,
        //   controller: minStockController,
        //   errorText: null,
        //   hintText: 'MS ex'.tr,
        //   iconName: 'inventory',
        //   onChanged: onMinStockChanged,
        // ),
        SizedBox(height: context.h * 0.02),
        TextFieldBlock(
          label: 'Medical Notes'.tr,
          isRequired: false,
          controller: notesController,
          //errorText: null,
          hintText: ' ...',
          iconName: 'note',
          onChanged: onNotesChanged,
        ),
      ],
    );
  }
}
