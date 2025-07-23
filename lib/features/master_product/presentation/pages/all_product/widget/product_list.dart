import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/subwidget/product_widget.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
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
  }
}
