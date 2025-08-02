import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/card_container.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/drop_down_block.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/text_field_block.dart';

class ProductDetailsCard extends StatelessWidget {
    final TextEditingController quantityController;
  final String? selectedForm;
  final String? selectedManufacturer;
  final String? formError;
  // final String? manufacturerError;
  // final String? quantityError;
  final VoidCallback onFormTap;
  final VoidCallback onManufacturerTap;
  final VoidCallback onQuantityChanged;

  const ProductDetailsCard({
    super.key,
    required this.quantityController,
    required this.selectedForm,
    required this.selectedManufacturer,
    this.formError,
    //this.manufacturerError,
    //this.quantityError,
    required this.onFormTap,
    required this.onManufacturerTap,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      iconName: 'info',
      labelName: 'Product Details'.tr,
      widgets: [
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
            //errorText: quantityError,
            hintText: 'MS ex'.tr,
            iconName: 'countertops',
            onChanged: onQuantityChanged),
      ],
    );
  }
}
