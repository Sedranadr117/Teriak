import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/widgets/custom_binding_widget.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/widgets/save_product_button.dart';
import 'package:teriak/features/suppliers/add_supplier/presentation/pages/widgets/supplier_form_widget.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/suppliers/edit_supplier/presentation/controller/edit_supplier_controller.dart';

import './widgets/edit_supplier_header_widget.dart';

class EditSupplierScreen extends StatefulWidget {
  const EditSupplierScreen({super.key});

  @override
  State<EditSupplierScreen> createState() => _EditSupplierScreenState();
}

class _EditSupplierScreenState extends State<EditSupplierScreen> {
  final editController = Get.put(EditSupplierController());
  final supplierController = Get.find<GetAllSupplierController>();

  late SupplierModel supplier;

  @override
  void initState() {
    super.initState();
    supplier = Get.arguments as SupplierModel;
    editController.loadSupplierData(supplier);

    
    editController.nameController.addListener(_updateState);
    editController.phoneController.addListener(_updateState);
    editController.addressController.addListener(_updateState);
  }


  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Supplier',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Widget
              EditSupplierHeaderWidget(
                supplierData: supplier,
              ),
              SizedBox(height: 3.h),
              Obx(
                () => SupplierFormWidget(
                  nameController: editController.nameController,
                  phoneController: editController.phoneController,
                  addressController: editController.addressController,
                  selectedCurrency: editController.selectedCurrency.value,
                  onCurrencyChanged: editController.updateCurrency,
                ),
              ),
              SizedBox(height: 1.h),
              SaveProductButton(
                  isFormValid: editController.isFormValid,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    editController.editSupplier(supplier.id);
                    supplierController.refreshSuppliers();

                    setState(() {});
                  },
                  label: "Save Supplier"),
              CommonWidgets.buildRequiredWidget(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
