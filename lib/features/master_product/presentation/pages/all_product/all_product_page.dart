import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/master_product/presentation/controller/get_allProduct_controller.dart';

import 'package:teriak/features/master_product/presentation/pages/all_product/widget/add_product_button.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/widget/product_list.dart';
import 'package:teriak/features/search_product/presentation/controller/search_product_controller.dart';
import 'package:teriak/features/search_product/presentation/pages/search_bar.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  final allController = Get.put(GetAllProductController());
  final searchController = Get.put(SearchProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: const SafeArea(
          child: Column(
            children: [
              SearchWidget(),
              ProductList(),
            ],
          ),
        ),
        floatingActionButton: AddButton(
          onTap: () {
            Get.toNamed(AppPages.addProductPage);
          },
          label: 'Add Product'.tr,
        ));
  }
}
