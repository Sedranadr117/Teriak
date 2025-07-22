import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:teriak/features/master_product/presentation/pages/all_product/widget/add_product_button.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/widget/product_list.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/widget/search_bar.dart';


class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pharmacy Product'.tr,
            style:Theme.of(context).textTheme.titleLarge
          ),
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
