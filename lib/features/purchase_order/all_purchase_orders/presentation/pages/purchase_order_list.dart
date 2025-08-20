import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/products/all_products/presentation/pages/all_product/widget/add_product_button.dart';
import 'package:teriak/features/purchase_order/search_purchase_order/presentation/controller/search_purchase_order_controller.dart';
import 'package:teriak/features/purchase_order/search_purchase_order/presentation/pages/search_section.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import './widgets/purchase_order_card.dart';
import '../controller/all_purchase_order_controller.dart';

class PurchaseOrderList extends StatefulWidget {
  const PurchaseOrderList({super.key});

  @override
  State<PurchaseOrderList> createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends State<PurchaseOrderList> {
  final controller = Get.put(GetAllPurchaseOrderController());
  final supplierController = Get.find<GetAllSupplierController>();
  final searchController = Get.put(SearchPurchaseOrderController());
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
      if (searchController.hasSearchResults.value) {
        searchController.loadNextPage();
      } else {
        controller.loadNextPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(height: 1.h),
            SearchSection(
              suppliers: supplierController.suppliers.cast(),
              onSupplierSelected: searchController.selectSupplier,
              selectedSupplier: searchController.selectedSupplier.value,
              errorText: searchController.searchError.value.isNotEmpty
                  ? searchController.searchError.value
                  : null,
              searchController: searchController,
            ),
            SizedBox(height: 1.h),

            // Clear Search Button (when search results are shown)
            Obx(() {
              if (searchController.hasSearchResults.value) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      searchController.resetSearch();
                      setState(() {});
                    },
                    icon: Icon(Icons.clear_all, size: 5.sp),
                    label: Text('Clear search'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.grey.shade700,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            SizedBox(height: 1.h),

            // Search Results or All Orders
            Expanded(
              child: Obx(() {
                if (searchController.hasSearchResults.value) {
                  return _buildSearchResults();
                } else {
                  return _buildAllOrders();
                }
              }),
            ),

            // Pagination Info
            Obx(() {
              if (searchController.hasSearchResults.value) {
                if (searchController.totalElements.value > 0) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${searchController.totalElements.value} orders'
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
                return const SizedBox.shrink();
              } else {
                if (controller.totalElements.value > 0) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: ${controller.totalElements.value} orders'.tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Page ${controller.currentPage.value + 1} of ${controller.totalPages.value}'
                              .tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
        floatingActionButton: AddButton(
          onTap: () {
            Get.toNamed(AppPages.createPurchaseOrder);
          },
          label: 'New Order'.tr,
        ));
  }

  Widget _buildSearchResults() {
    if (searchController.isSearchingSupplier.value||searchController.isSearchingDate.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchController.searchError.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Text(
              searchController.searchError.value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            // SizedBox(height: 2.h),
            // ElevatedButton(
            //   onPressed: () => searchController.resetSearch(),
            //   child: Text('Clear Search'.tr),
            // ),
          ],
        ),
      );
    }

    if (searchController.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No search results found'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () => searchController.resetSearch(),
              child: Text('Clear search'.tr),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (searchController.selectedSupplier.value != null) {
          await searchController.searchBySupplier();
        } else if (searchController.startDate.value != null &&
            searchController.endDate.value != null) {
          await searchController.searchByDateRange();
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: searchController.searchResults.length +
            (searchController.hasNext.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == searchController.searchResults.length) {
            return Obx(() {
              if (searchController.isSearchingSupplier.value||searchController.isSearchingDate.value) {
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

          final order = searchController.searchResults[index];
          return PurchaseOrderCard(
            orderData: order,
            onTap: () => Get.toNamed(
              AppPages.purchaseOrderDetail,
              arguments: {
                'id': order.id,
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllOrders() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Text(
              controller.errorMessage.value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () => controller.getPurchaseOrders(),
              child: Text('Retry'.tr),
            ),
          ],
        ),
      );
    }

    if (controller.purchaseOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No purchase orders found'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return Container(
       margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'All Purchase Orders'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          Expanded(
            child: RefreshIndicator(
               onRefresh: controller.refreshPurchaseOrders,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: controller.purchaseOrders.length +
                    (controller.hasNext.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.purchaseOrders.length) {
                    return Obx(() {
                      if (controller.isLoadingMore.value) {
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
              
                  final order = controller.purchaseOrders[index];
                  return PurchaseOrderCard(
                    orderData: order,
                    onTap: () => Get.toNamed(
                      AppPages.purchaseOrderDetail,
                      arguments: {
                        'id': order.id,
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}