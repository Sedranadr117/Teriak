import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/card_container.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/text_field_block.dart';

class BasicInformationCard extends StatelessWidget {
  final TextEditingController arabicTradeNameController;
  final TextEditingController englishTradeNameController;
  final TextEditingController arabicScientificNameController;
  final TextEditingController englishScientificNameController;

  // final String arabicTradeNameError;
  // final String englishTradeNameError;
  final VoidCallback onArabicTradeNameChanged;
  final VoidCallback onEnglishTradeNameChanged;

  final VoidCallback onArabicScientificNameChanged;
  final VoidCallback onEnglishScientificNameChanged;

  const BasicInformationCard(
      {super.key,
      required this.arabicTradeNameController,
      required this.englishTradeNameController,
      required this.arabicScientificNameController,
      required this.englishScientificNameController,
      // required this.arabicTradeNameError,
      // required this.englishTradeNameError,
      required this.onArabicTradeNameChanged,
      required this.onEnglishTradeNameChanged,
      required this.onArabicScientificNameChanged,
      required this.onEnglishScientificNameChanged});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      iconName: 'medical_services',
      labelName: 'Basic Info'.tr,
      widgets: [
        SizedBox(height: context.h * 0.03),
    TextFieldBlock(
              label: 'Trade Product Name ar'.tr,
              isRequired: true,
              controller: arabicTradeNameController,
              //errorText: error,
              hintText: 'Enter Tr Product Name ar'.tr,
              iconName: 'language',
              onChanged: onArabicTradeNameChanged,
            ),
        SizedBox(height: context.h * 0.02),

        TextFieldBlock(
              label: 'Trade Product Name en'.tr,
              isRequired: true,
              controller: englishTradeNameController,
              //errorText: error,
              hintText: 'Enter Tr Product Name en'.tr,
              iconName: 'translate',
              onChanged: onEnglishTradeNameChanged,
            ),
        SizedBox(height: context.h * 0.02),
        TextFieldBlock(
          label: 'Sc Product Name ar'.tr,
          isRequired: false,
          controller: arabicScientificNameController,
          //errorText: null,
          hintText: 'Enter Sc Product Name ar'.tr,
          iconName: 'language',
          onChanged: onArabicScientificNameChanged,
        ),
        SizedBox(height: context.h * 0.02),
        TextFieldBlock(
          label: 'Sc Product Name en'.tr,
          isRequired: false,
          controller: englishScientificNameController,
          //errorText: null,
          hintText: 'Enter Sc Product Name en'.tr,
          iconName: 'translate',
          onChanged: onEnglishScientificNameChanged,
        ),
        SizedBox(height: context.h * 0.02),
      ],
    );
  }
}
