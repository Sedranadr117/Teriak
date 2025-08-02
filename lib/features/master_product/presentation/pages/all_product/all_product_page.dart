import 'package:flutter/material.dart';
import 'package:get/get.dart';
<<<<<<< HEAD

import 'package:teriak/features/master_product/presentation/pages/all_product/widget/add_product_button.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/widget/product_list.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/widget/search_bar.dart';

=======
import 'package:teriak/features/master_product/presentation/controller/get_allProduct_controller.dart';

import 'package:teriak/features/master_product/presentation/pages/all_product/widget/add_product_button.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/widget/product_list.dart';
import 'package:teriak/features/search_product/presentation/controller/search_product_controller.dart';
import 'package:teriak/features/search_product/presentation/pages/search_bar.dart';
>>>>>>> products

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pharmacy Product'.tr,
            style:Theme.of(context).textTheme.titleLarge
          ),
=======
  final allController = Get.put(GetAllProductController());
  final searchController = Get.put(SearchProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Pharmacy Product'.tr,
              style: Theme.of(context).textTheme.titleLarge),
>>>>>>> products
        ),
        body: const SafeArea(
          child: Column(
            children: [
              SearchWidget(),
              ProductList(),
            ],
          ),
        ),
        floatingActionButton: const AddProductButton());
  }
}
