import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/subwidget/product_widget.dart';
=======
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/master_product/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/subwidget/product_widget.dart';
import 'package:teriak/features/search_product/presentation/controller/search_product_controller.dart';
>>>>>>> products

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
<<<<<<< HEAD
  final List<Map<String, dynamic>> productList = [
    {
      "tradeName": "Aspirin",
      "scientificName": "Acetylsalicylic Acid",
      "productSource": "Central",
      "drugQuantity": "30 pills",
      "dosageSize": "500",
      "dosageUnit": "mg",
      "prescriptionRequired": true,
      "drugForm": "Tablets",
      "medicalNotes": "you should eat before",
      "barcodes": ["1234567890", "9876543210"],
      "manufacturer": "Advanced Pharmaceuticals",
      "classification": "Analgesic & Anti-inflammatory",
      "productType": "Pain Relief Medication"
    },
    {
      "tradeName": "Paracetamol",
      "scientificName": "Acetaminophen",
      "productSource": "Pharmacy",
      "drugQuantity": "24 pills",
      "dosageSize": "500",
      "dosageUnit": "mg",
      "prescriptionRequired": false,
      "drugForm": "Tablets",
      "medicalNotes": "you should eat before",
      "barcodes": ["1234567890", "9876543210"],
      "manufacturer": "Advanced Pharmaceuticals",
      "classification": "Analgesic & Anti-inflammatory",
      "productType": "Pain Relief Medication"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
            horizontal: context.w * 0.04, vertical: context.h * 0.02),
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return Padding(
            padding: EdgeInsets.only(bottom: context.h * 0.02),
            child: ProductWidget(
              drug: product,
              onTap: () {
                Get.toNamed(
                  AppPages.productDetailPage,
                  arguments: product,
                );
              },
            ),
          );
        },
      ),
    );
=======
  final searchController = Get.find<SearchProductController>();
  final allController = Get.find<GetAllProductController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = searchController.searchStatus.value;

      if (status == null) {
        if (allController.isLoading.value) {
          return const Expanded(
              child: Center(child: CircularProgressIndicator()));
        }
        if (allController.errorMessage.isNotEmpty) {
          return Expanded(
              child: Center(child: Text(allController.errorMessage.value)));
        }
        if (allController.products.isEmpty) {
          return Expanded(child: Center(child: Text("empty list".tr)));
        }

        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: context.w * 0.04,
              vertical: context.h * 0.02,
            ),
            itemCount: allController.products.length,
            itemBuilder: (context, index) {
              final product = allController.products[index];
              return Padding(
                padding: EdgeInsets.only(bottom: context.h * 0.02),
                child: ProductWidget(
                  drug: product,
                  onTap: () {
                    searchController.searchFocus.unfocus();
                    print(product.productType);
                    Get.toNamed(
                      AppPages.productDetailPage,
                      
                      arguments: {
                        'id': product.id,
                        'type': product.productType,
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      }

      if (status.isLoading) {
        return const Expanded(
            child: Center(child: CircularProgressIndicator()));
      }

      if (status.isError) {
        return Expanded(
            child: Center(child: Text(searchController.errorMessage.value)));
      }

      if (status.isEmpty && searchController.results.isEmpty) {
        return Expanded(
          child: Center(child: Text('no search'.tr)),
        );
      }

      if (status.isSuccess) {
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: context.w * 0.04,
              vertical: context.h * 0.02,
            ),
            itemCount: searchController.results.length,
            itemBuilder: (context, index) {
              final product = searchController.results[index];
              return Padding(
                padding: EdgeInsets.only(bottom: context.h * 0.02),
                child: ProductWidget(
                  drug: product,
                  onTap: () {
                    searchController.searchFocus.unfocus();
                    Get.toNamed(
                      AppPages.productDetailPage,
                      arguments: {
                        'id': product.id,
                        'type': product.productType,
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      }

      return const SizedBox.shrink();
    });
>>>>>>> products
  }
}
