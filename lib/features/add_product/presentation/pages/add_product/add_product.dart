import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/widgets/custom_binding_widget.dart';
import 'package:teriak/features/add_product/presentation/controller/add_product_controller.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/widgets/save_product_button.dart';
import 'package:teriak/features/bottom_sheet_management/barcode_bottom_sheet.dart';
import 'package:teriak/features/bottom_sheet_management/multi_bottom_sheet.dart';
import 'package:teriak/features/bottom_sheet_management/single_bottom_sheet.dart';
import 'package:teriak/features/master_product/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/product_data/data/models/product_data_model.dart';
import 'package:teriak/features/product_data/presentation/controller/product_data_controller.dart';
import 'widgets/additional_information_card.dart';
import 'widgets/barcode_management_card.dart';
import 'widgets/basic_information_card.dart';
import 'widgets/product_details_card.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final addProductController = Get.put(AddProductController());
  final productDataController = Get.put(ProductDataController());
  final productController = Get.find<GetAllProductController>();

  @override
  void initState() {
    super.initState();

    addProductController.arabicTradeNameController.addListener(_updateState);
    addProductController.englishTradeNameController.addListener(_updateState);
    addProductController.quantityController.addListener(_updateState);
    addProductController.barcodeController.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = addProductController;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add New Product'.tr),
      ),
      body: SafeArea(
        child: Column(
          children: [
             
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: context.h * 0.02),
                child: Column(
                  children: [
                    const SizedBox(height: 3),
                    CommonWidgets.buildRequiredWidget(context: context),
                    const SizedBox(height: 8),
                    // Basic Information
                    BasicInformationCard(
                      arabicTradeNameController: c.arabicTradeNameController,
                      englishTradeNameController: c.englishTradeNameController,
                      onArabicTradeNameChanged: () => setState(() {}),
                      onEnglishTradeNameChanged: () => setState(() {}),
                      arabicScientificNameController:
                          c.arabicScientificNameController,
                      englishScientificNameController:
                          c.englishScientificNameController,
                      onArabicScientificNameChanged: () {},
                      onEnglishScientificNameChanged: () {},
                    ),

                    // Product Details
                    Obx(() => ProductDetailsCard(
                          quantityController: c.quantityController,
                          selectedForm: c.selectedForm.value,
                          selectedManufacturer: c.selectedManufacturer.value,
                          formError: c.formError.value,
                          onFormTap: () async {
                            await productDataController.getProductData('forms');
                            final list = productDataController.dataList
                                .cast<ProductDataModel>();

                            showDropdownBottomSheet(
                              title: 'Select Form'.tr,
                              items: list,
                              onSelected: (id, name) {
                                c.selectedFormId.value = id;
                                c.selectedForm.value = name;
                                c.formError.value = null;
                                setState(() {}); // تحديث اللون
                              },
                            );
                          },
                          onManufacturerTap: () async {
                            await productDataController
                                .getProductData('manufacturers');
                            final list = productDataController.dataList
                                .cast<ProductDataModel>();

                            showDropdownBottomSheet(
                              title: 'Select Manufacturer'.tr,
                              items: list,
                              onSelected: (id, name) {
                                c.selectedManufacturerId.value = id;
                                c.selectedManufacturer.value = name;
                                c.manufacturerError.value = null;
                                setState(() {}); // تحديث اللون
                              },
                            );
                          },
                          onQuantityChanged: () => setState(() {}),
                        )),

                    // Barcode management
                    Obx(() {
                      return BarcodeManagementCard(
                        barcodes: c.barcodes.toList(),
                        barcodeController: c.barcodeController,
                        onAddBarcode: () {
                          c.addBarcode();
                          setState(() {});
                        },
                        onRemoveBarcode: (index) {
                          c.removeBarcode(index);
                          setState(() {});
                        },
                        onScanBarcode: () {
                          showBarcodeScannerBottomSheet(
                            onScanned: (value) {
                              c.addScannedBarcode(value);
                              setState(() {});
                            },
                          );
                        },
                      );
                    }),

                    // Additional Information
                    Obx(() => AdditionalInformationCard(
                          dosageController: c.dosageController,
                          notesController: c.notesController,
                          selectedProductType: c.selectedProductType.value,
                          selectedClassification: c.selectedCategoryIds.isEmpty
                              ? null
                              : c.getSelectedCategoryNames(),
                          requiresPrescription: c.requiresPrescription.value,
                          onProductTypeTap: () async {
                            await productDataController.getProductData('types');
                            final list = productDataController.dataList
                                .cast<ProductDataModel>();

                            showDropdownBottomSheet(
                              title: 'Select Product Type'.tr,
                              items: list,
                              onSelected: (id, name) {
                                c.selectedTypeId.value = id;
                                c.selectedProductType.value = name;
                              },
                            );
                          },
                          onClassificationTap: () async {
                            final productDataController =
                                Get.find<ProductDataController>();
                            await productDataController
                                .getProductData('categories');

                            showMultiSelectBottomSheet(
                              title: 'Select Classification'.tr,
                              items: productDataController.dataList
                                  .cast<ProductDataModel>(),
                              selectedIds: c.selectedCategoryIds.toList(),
                              onSelectionChanged: (selectedIds) {
                                c.selectedCategoryIds.assignAll(selectedIds);
                              },
                            );
                          },
                          onPrescriptionToggle: (value) {
                            c.requiresPrescription.value = value;
                          },
                          onNotesChanged: () {},
                          onDosageChanged: () {},
                        )),
                  ],
                ),
              ),
            ),
           
            SaveProductButton(
              isFormValid: c.isFormValid,
              onTap: () {
                FocusScope.of(context).unfocus();
                c.addProduct();
                productController.refreshProducts();
                setState(() {});
              },
              label: "Save Product".tr,
            ),
          ],
        ),
      ),
    );
  }
}
