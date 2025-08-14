import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/widget/add_product_button.dart';
import './widgets/purchase_order_card.dart';
import '../controller/all_purchase_order_controller.dart';

class PurchaseOrderList extends StatefulWidget {
  const PurchaseOrderList({super.key});

  @override
  State<PurchaseOrderList> createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends State<PurchaseOrderList> {
  final controller = Get.put(GetAllPurchaseOrderController());
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
      controller.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(height: 2.h),
            //PurchaseSearchWidget(),
            //SizedBox(height: 2.h),
            Expanded(
              child: Obx(() {
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

                return _buildOrdersList();
              }),
            ),
            // Pagination Info
            Obx(() {
              if (controller.totalElements.value > 0) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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

  Widget _buildOrdersList() {
    return RefreshIndicator(
      onRefresh: controller.refreshPurchaseOrders,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: controller.purchaseOrders.length +
            (controller.hasNext.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == controller.purchaseOrders.length) {
            // Loading indicator for next page
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
    );
  }
}
