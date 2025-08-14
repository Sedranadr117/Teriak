import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/drop_down_block.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/subWidget/text_field_block.dart';
import 'package:teriak/features/suppliers/add_supplier/presentation/pages/widgets/currency_bootom_sheet.dart';

class SupplierFormWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;

  const SupplierFormWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  State<SupplierFormWidget> createState() => _SupplierFormWidgetState();
}

class _SupplierFormWidgetState extends State<SupplierFormWidget> {
  final List<Map<String, String>> currencies = [
    {"code": "USD", "symbol": "\$"},
    {"code": "SYP","symbol": "ل.س"},
  ];
  @override
  Widget build(BuildContext context) {
    final selectedCurrencyData = currencies.firstWhere(
      (currency) => currency['code'] == widget.selectedCurrency,
      orElse: () => currencies.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldBlock(
          label: 'Supplier Name',
          isRequired: true,
          controller: widget.nameController,
          //errorText: error,
          hintText: 'Enter supplier name',
          iconName: 'business',
          onChanged: () {},
        ),

        SizedBox(height: 2.h),
        TextFieldBlock(
          label: 'Phone Number',
          isRequired: true,
          controller: widget.phoneController,
          //errorText: error,
          hintText: '09xxxxxxxx',
          iconName: 'phone',
          onChanged: () {},
        ),
        SizedBox(height: 2.h),
        TextFieldBlock(
          label: 'Address',
          isRequired: true,
          controller: widget.addressController,
          //errorText: error,
          hintText: 'Enter supplier address',
          iconName: 'location_on',
          onChanged: () {},
        ),
        SizedBox(height: 2.h),
        DropDownBlock(
          label: 'Preferred Currency',
          isRequired: true,
          iconName: 'currency',
          value: widget.selectedCurrency,
          onTap: () => CurrencyPickerBottomSheet.show(
            context: context,
            currencies: currencies,
            selectedCurrency: selectedCurrencyData['code']!,
            onCurrencyChanged: widget.onCurrencyChanged,
          ),
        ),
      ],
    );
  }
}
