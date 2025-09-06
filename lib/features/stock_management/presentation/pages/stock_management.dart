import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/bottom_sheet_management/barcode_bottom_sheet.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_item_entity.dart';
import 'package:teriak/features/stock_management/presentation/controller/stock_controller.dart';
import 'package:teriak/features/stock_management/presentation/widgets/product_card.dart';
import 'package:teriak/main.dart';
import '../widgets/stock_search_bar.dart';
import '../widgets/stock_adjustment_sheet.dart';

class StockManagement extends StatefulWidget {
  const StockManagement({super.key});

  @override
  State<StockManagement> createState() => _StockManagementState();
}

class _StockManagementState extends State<StockManagement>
    with TickerProviderStateMixin {
  late StockController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(StockController());
    controller.tabController = TabController(length: 3, vsync: this);
    controller.fetchStock();
  }

  void _showProductDetails(Map<String, dynamic> product) {
    final productId = product['productId'];
    final productType = product['productType'];
    controller.fetchStockDetails(
      productId: productId,
      productType: productType,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Obx(() {
        return _buildProductDetailsSheetFromEndpoint(
            controller.stockDetails, product);
      }),
    );
  }

  Widget _buildProductDetailsSheetFromEndpoint(
      List<StockDetailsEntity> details, Map<String, dynamic> product) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product Details'.tr,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(
                  product['productName'].toString(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: controller.isLoading.value
                ? _buildLoadingView(theme, colorScheme)
                : ListView.builder(
                    padding: EdgeInsets.all(4.w),
                    itemCount: details.length,
                    itemBuilder: (context, index) {
                      final detail = details[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detail.stockItems.map((stockItem) {
                          return Card(
                            color: theme.cardColor,
                            elevation: 1,
                            margin: EdgeInsets.symmetric(vertical: 1.h),
                            child: Padding(
                              padding: EdgeInsets.all(5.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(
                                      'Batch:'.tr, stockItem.batchNo),
                                  _buildDetailRow(
                                      'Quantity:'.tr,
                                      (stockItem.quantity as num)
                                          .toStringAsFixed(2)),
                                  _buildDetailRow('Bonus'.tr,
                                      (stockItem.bonusQty as num).toString()),
                                  _buildDetailRow(
                                    'Supplier'.tr,
                                    stockItem.supplier,
                                  ),
                                  _buildDetailRow(
                                    'Expiry'.tr,
                                    stockItem.expiryDate != null
                                        ? '${stockItem.expiryDate!.day}/${stockItem.expiryDate!.month}/${stockItem.expiryDate!.year}'
                                        : 'N/A',
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withAlpha(77),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
          ),
          role == 'PHARMACY_TRAINEE'
              ? SizedBox()
              : Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showStockAdjustmentSheet(product);
                          },
                          child: Text('Adjust Stock'.tr),
                        ),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: colorScheme.error, width: 1.5),
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            _deleteStock(product);
                          },
                          child: Text(
                            'Delete Stock'.tr,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void _deleteStock(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete From Stock'.tr),
        content: Text(
            '${'Are you sure you want to remove'.tr} ${product['productName']} ${'from Stock?'.tr}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteStock(product['id']);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Delete'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showStockAdjustmentSheet(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Obx(
        () => StockAdjustmentSheet(
          isLoading: controller.isLoading.value,
          product: product,
          onAdjustmentSubmitted: (StockParams params) async {
            await controller.editStock(product['id'], params);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          StockSearchBar(
            onSearchChanged: (query) {
              controller.results.clear();
              controller.search(query.trim());
            },
            onScanPressed: () {
              showBarcodeScannerBottomSheet(
                onScanned: (code) {
                  controller.searchController.text = code;
                  controller.search(code);
                },
              );
            },
            searchController: controller.searchController,
          ),
          TabBar(
            isScrollable: true,
            controller: controller.tabController,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.zero,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'inventory_2_outlined',
                      color: controller.tabController.index == 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text('All Stock'.tr),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'warning_amber_outlined',
                      color: controller.tabController.index == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text('Low Stock'.tr),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule_outlined',
                      color: controller.tabController.index == 2
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text('Near Expiry'.tr),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(controller: controller.tabController, children: [
              Obx(() => _buildStockList(
                  controller.applyFilters(0), theme, colorScheme)),
              Obx(() => _buildStockList(
                  controller.applyFilters(1), theme, colorScheme)),
              Obx(() => _buildStockList(
                  controller.applyFilters(2), theme, colorScheme))
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildStockList(List<Map<String, dynamic>> stock, ThemeData theme,
      ColorScheme colorScheme) {
    List<Map<String, dynamic>> displayList =
        controller.searchController.text.trim().isNotEmpty
            ? controller.results
                .map((product) => {
                      'id': product.id,
                      'productId': product.productId,
                      'productName': product.productName,
                      'productType': product.productType,
                      'barcodes': product.barcodes,
                      'totalQuantity': product.totalQuantity,
                      'totalBonusQuantity': product.totalBonusQuantity,
                      'totalValue': product.totalValue,
                      'categories': product.categories,
                      'sellingPrice': product.sellingPrice,
                      'minStockLevel': product.minStockLevel,
                      'hasExpiredItems': product.hasExpiredItems,
                      'hasExpiringSoonItems': product.hasExpiringSoonItems,
                      'earliestExpiryDate':
                          product.earliestExpiryDate?.toIso8601String(),
                      'latestExpiryDate':
                          product.latestExpiryDate?.toIso8601String(),
                      'numberOfBatches': product.numberOfBatches,
                      'pharmacyId': product.pharmacyId,
                    })
                .toList()
            : stock;

    if (controller.isLoading.value) {
      return _buildLoadingView(theme, colorScheme);
    }

    if (displayList.isEmpty) {
      return _buildEmptyView(theme, colorScheme);
    }

    return RefreshIndicator(
      onRefresh: controller.refreshStock,
      child: controller.isLoading.value
          ? _buildLoadingView(theme, colorScheme)
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 10.h),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final product = displayList[index];
                final mapy = {
                  'id': product['id'],
                  'productId': product['productId'],
                  'productName': product['productName'],
                  'productType': product['productType'],
                  'barcodes': product['barcodes'],
                  'totalQuantity': product['totalQuantity'],
                  'totalBonusQuantity': product['totalBonusQuantity'],
                  'averagePurchasePrice': product['averagePurchasePrice'],
                  'totalValue': product['totalValue'],
                  'categories': product['categories'],
                  'sellingPrice': product['sellingPrice'],
                  'minStockLevel': product['minStockLevel'],
                  'hasExpiredItems': product['hasExpiredItems'],
                  'hasExpiringSoonItems':
                      product['hasExpiringSoonItems'] ?? false,
                  'earliestExpiryDate': product['earliestExpiryDate'] ?? false,
                  'latestExpiryDate': product['latestExpiryDate'],
                  'numberOfBatches': product['numberOfBatches'],
                  'pharmacyId': product['pharmacyId'],
                };
                return ProductCard(
                  product: mapy,
                  onTap: () => _showProductDetails(mapy),
                  onAdjustStock: () => _showStockAdjustmentSheet(mapy),
                );
              },
            ),
    );
  }

  Widget _buildLoadingView(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 2.h),
          Text(
            'Loading...'.tr,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'Stock_2',
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            size: 20.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No products found'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search or filters'.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          IconButton(
              onPressed: controller.refreshStock, icon: Icon(Icons.refresh))
        ],
      ),
    );
  }
}
