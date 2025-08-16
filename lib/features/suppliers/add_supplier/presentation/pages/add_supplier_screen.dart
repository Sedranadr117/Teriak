import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/widgets/custom_binding_widget.dart';
import 'package:teriak/features/products/add_product/presentation/pages/add_product/widgets/save_product_button.dart';
import 'package:teriak/features/suppliers/add_supplier/presentation/controller/add_supplier_controller.dart';
import 'package:teriak/features/suppliers/add_supplier/presentation/pages/widgets/header_widget.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';

import './widgets/supplier_form_widget.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final addController = Get.put(AddSupplierController());
  final supplierController = Get.find<GetAllSupplierController>();
  @override
  void initState() {
    super.initState();

    addController.nameController.addListener(_updateState);
    addController.phoneController.addListener(_updateState);
    addController.addressController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Add Supplier'.tr,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 1,
        shadowColor: Theme.of(context).shadowColor.withValues(alpha: 0.1),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            SizedBox(height: 3.h),
            Obx(
              () => SupplierFormWidget(
                nameController: addController.nameController,
                phoneController: addController.phoneController,
                addressController: addController.addressController,
                selectedCurrency: addController.selectedCurrency.value,
                onCurrencyChanged: addController.updateCurrency,
              ),
            ),
            SizedBox(height: 1.h),
            SaveProductButton(
                isFormValid: addController.isFormValid,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  addController.addSupplier();
                  supplierController.refreshSuppliers();

                  setState(() {});
                },
                label: "Save Supplier".tr),
            CommonWidgets.buildRequiredWidget(context: context),
          ],
        ),
      ),
    );
  }
}
