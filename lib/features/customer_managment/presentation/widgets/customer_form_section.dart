import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sizer/sizer.dart';

class CustomerFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController notesController;
  final TextEditingController addressController;

  const CustomerFormSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.notesController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Full Name *'.tr,
            hintText: 'Enter customer full name'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.person),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter customer name'.tr;
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters'.tr;
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number *'.tr,
            hintText: 'Enter phone number'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter phone number'.tr;
            }
            if (value.trim().length < 10) {
              return 'Please enter a valid phone number'.tr;
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Address *'.tr,
            hintText: 'Enter customer address'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.location_on),
          ),
          textCapitalization: TextCapitalization.words,
          maxLines: 1,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter customer address'.tr;
            }
            if (value.trim().length < 5) {
              return 'Please enter a valid address'.tr;
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: notesController,
          decoration: InputDecoration(
            labelText: 'Notes'.tr,
            hintText: 'Add any additional notes about this customer...'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.note),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
}
