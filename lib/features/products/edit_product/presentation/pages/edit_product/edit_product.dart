import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/widgets/custom_binding_widget.dart';
import 'package:teriak/features/products/add_product/presentation/pages/add_product/widgets/save_product_button.dart';
import 'package:teriak/features/bottom_sheet_management/barcode_bottom_sheet.dart';
import 'package:teriak/features/bottom_sheet_management/multi_bottom_sheet.dart';
import 'package:teriak/features/bottom_sheet_management/single_bottom_sheet.dart';
import 'package:teriak/features/products/edit_product/presentation/controller/edit_product_controller.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';
import 'package:teriak/features/products/product_data/presentation/controller/product_data_controller.dart';
import 'package:teriak/features/products/product_data/presentation/controller/product_names_controller.dart';
import 'package:teriak/features/products/product_details/presentation/controller/get_product_details_controller.dart';
import 'package:teriak/main.dart';

import 'widgets/basic_information_section.dart';
import 'widgets/barcode_management_section.dart';
import 'widgets/additional_information_section.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late ProductModel product;
  final editController = Get.put(EditProductController());
  final productDataController = Get.put(ProductDataController());
  final namesController =Get.find<ProductNamesController>();
  final productController = Get.find<GetAllProductController>();
  final productDetailsController = Get.find<GetProductDetailsController>();

  @override
  void initState() {
    super.initState();
    product = Get.arguments as ProductModel;
    editController.loadProductData(product);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Product'.tr),
            if (product.tradeName.isNotEmpty)
              Text(
                product.tradeName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ),
          ],
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 3),
                    CommonWidgets.buildRequiredWidget(context: context),
                    const SizedBox(height: 8),
                    Obx(
                      () {
                        return BasicInformationSection(
                          arabicTradeNameController:
                              editController.arabicTradeNameController,
                          englishTradeNameController:
                              editController.englishTradeNameController,
                          arabicScientificNameController:
                              editController.arabicScientificNameController,
                          englishScientificNameController:
                              editController.englishScientificNameController,
                          isExpanded: editController.basicInfoExpanded.value,
                          onToggle: () {
                            editController.basicInfoExpanded.value =
                                !editController.basicInfoExpanded.value;
                          },
                        );
                      },
                    ),
                    (role != "PHARMACY_MANAGER")
                        ? Container()
                        : Obx(
                            () => BarcodeManagementSection(
                              barcodes: editController.barcodes.toList(),
                              barcodeController:
                                  editController.barcodeController,
                              onAddBarcode: editController.addBarcode,
                              onRemoveBarcode: (index) =>
                                  editController.removeBarcode(index),
                              onScanBarcode: () {
                                showBarcodeScannerBottomSheet(
                                  onScanned: (value) {
                                    editController.addScannedBarcode(value);
                                  },
                                );
                              },
                              isExpanded: editController.barcodeExpanded.value,
                              onToggle: () {
                                setState(() {
                                  editController.barcodeExpanded.value =
                                      !editController.barcodeExpanded.value;
                                });
                              },
                            ),
                          ),
                    AdditionalInformationSection(
                      dosageController: editController.dosageController,
                      notesController: editController.notesController,
                      quantityController: editController.sizeController,
                      selectedForm: editController.selectedForm.value,
                      selectedManufacturer:
                          editController.selectedManufacturer.value,
                      selectedProductType:
                          editController.selectedProductType.value,
                      selectedClassification:
                          editController.getSelectedCategoryNames(),
                      requiresPrescription:
                          editController.requiresPrescription.value,
                      onPrescriptionChanged: (value) {
                        setState(() {
                          editController.requiresPrescription.value = value;
                        });
                      },
                      onFormTap: () async {
                        await productDataController.getProductData('forms');
                        final list = productDataController.dataList
                            .cast<ProductDataModel>();

                        showDropdownBottomSheet(
                          title: 'Select Form'.tr,
                          items: list,
                          onSelected: (id, name) {
                            setState(() {
                              editController.selectedFormId.value = id;
                              editController.selectedForm.value = name;
                            });
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
                            setState(() {
                              editController.selectedManufacturerId.value = id;
                              editController.selectedManufacturer.value = name;
                            });
                          },
                        );
                      },
                      onProductTypeTap: () async {
                        await productDataController.getProductData('types');
                        final list = productDataController.dataList
                            .cast<ProductDataModel>();

                        showDropdownBottomSheet(
                          title: 'Select Product Type'.tr,
                          items: list,
                          onSelected: (id, name) {
                            setState(() {
                              editController.selectedTypeId.value = id;
                              editController.selectedProductType.value = name;
                            });
                          },
                        );
                      },
                      onClassificationTap: () async {
                        await productDataController
                            .getProductData('categories');

                        showMultiSelectBottomSheet(
                          title: 'Select Classification'.tr,
                          items: productDataController.dataList
                              .cast<ProductDataModel>(),
                          selectedIds:
                              editController.selectedCategoryIds.toList(),
                          onSelectionChanged: (selectedIds) {
                            setState(() {
                              editController.selectedCategoryIds
                                  .assignAll(selectedIds);
                            });
                          },
                        );
                      },
                      isExpanded: editController.additionalInfoExpanded.value,
                      onToggle: () {
                        setState(() {
                          editController.additionalInfoExpanded.value =
                              !editController.additionalInfoExpanded.value;
                        });
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Obx(()=>
              SaveProductButton(
                isLoading: editController.isLoading.value,
                isFormValid: editController.isFormValid,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  await editController.editProduct(product.id);
                  productController.refreshProducts();
                  productDetailsController.getProductDetails(
                      id: product.id, type: product.productType);
                },
                label: "Save Product".tr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
