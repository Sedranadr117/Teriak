import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/master_product/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/subwidget/product_widget.dart';
import 'package:teriak/features/search_product/presentation/controller/search_product_controller.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
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
  }
}
