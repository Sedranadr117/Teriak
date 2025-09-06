import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/products/all_products/presentation/pages/all_product/widget/add_product_button.dart';
import 'package:teriak/features/products/search_product/presentation/controller/search_product_controller.dart';
import 'package:teriak/features/products/all_products/presentation/pages/all_product/subwidget/product_widget.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/features/products/search_product/presentation/pages/search_bar.dart';

class AllProductPage extends StatefulWidget {
  const AllProductPage({super.key});

  @override
  State<AllProductPage> createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  final allController = Get.put(GetAllProductController());
  final searchController = Get.put(SearchProductController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (searchController.results.isNotEmpty) {
        searchController.loadNextPage();
      } else {
        allController.loadNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Pharmacy Product".tr,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            SearchWidget(),

            // Product list
            Expanded(
              child: ProductList(scrollController: _scrollController),
            ),

            // Pagination info
            Obx(() {
              if (searchController.results.isNotEmpty) {
                if (searchController.totalElements.value > 0) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${searchController.totalElements.value} products'
                              .tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Page ${searchController.currentPage.value + 1} of ${searchController.totalPages.value}'
                              .tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }
              } else {
                if (allController.totalElements.value > 0) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${allController.totalElements.value} products'
                              .tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Page ${allController.currentPage.value + 1} of ${allController.totalPages.value}'
                              .tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
      floatingActionButton: AddButton(
        onTap: () {
          Get.toNamed(AppPages.addProductPage);
        },
        label: 'Add Product'.tr,
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final ScrollController scrollController;

  ProductList({super.key, required this.scrollController});

  final searchController = Get.find<SearchProductController>();
  final allController = Get.find<GetAllProductController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = searchController.searchStatus.value;

      if (status == null) {
        if (allController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (allController.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error'.tr, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 2.h),
                Text(
                  allController.errorMessage.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: () => allController.refreshProducts(),
                  child: Text('Retry'.tr),
                ),
              ],
            ),
          );
        }
        if (allController.products.isEmpty) {
          return Center(
              child: Column(
            children: [
              Text("empty list".tr),
              SizedBox(height: 2.h),
              ElevatedButton(
                onPressed: () => allController.refreshProducts(),
                child: Text('Retry'.tr),
              ),
            ],
          ));
        }

        return RefreshIndicator(
          onRefresh: () => allController.refreshProducts(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: context.w * 0.04,
              vertical: context.h * 0.02,
            ),
            itemCount: allController.products.length +
                (allController.hasNext.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == allController.products.length) {
                return Obx(() {
                  if (allController.isLoadingMore.value) {
                    return Container(
                      padding: EdgeInsets.all(4.w),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                });
              }

              final product = allController.products[index];
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
                        'type': product.productType
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
      }

      // أثناء البحث
      if (status.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (status.isError) {
        return Center(child: Text(searchController.errorMessage.value));
      }
      if (status.isEmpty && searchController.results.isEmpty) {
        return Column(
          children: [
            Center(child: Text('no search'.tr)),
          ],
        );
      }

      if (status.isSuccess) {
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: context.w * 0.04,
            vertical: context.h * 0.02,
          ),
          itemCount: searchController.results.length +
              (searchController.hasNext.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == searchController.results.length) {
              return Obx(() {
                if (searchController.isSearching.value) {
                  return Container(
                    padding: EdgeInsets.all(4.w),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              });
            }

            final product = searchController.results[index];
            return Padding(
              padding: EdgeInsets.only(bottom: context.h * 0.02),
              child: ProductWidget(
                drug: product,
                onTap: () {
                  searchController.searchFocus.unfocus();
                  Get.toNamed(
                    AppPages.productDetailPage,
                    arguments: {'id': product.id, 'type': product.productType},
                  );
                },
              ),
            );
          },
        );
      }

      return const SizedBox.shrink();
    });
  }
}
