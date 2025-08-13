import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/config/widgets/custom_tab_bar.dart';
import 'package:teriak/features/bottom_sheet_management/barcode_bottom_sheet.dart';
import 'package:teriak/features/stock_management/presentation/controller/stock_controller.dart';
import '../widgets/stock_search_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/stock_adjustment_sheet.dart';

class StockManagement extends StatefulWidget {
  const StockManagement({super.key});

  @override
  State<StockManagement> createState() => _StockManagementState();
}

class _StockManagementState extends State<StockManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final bool _isLoading = false;
  final List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: stockController.tabs.length, vsync: this);
    stockController.fetchStock();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    // Apply tab-specific filters
    switch (_tabController.index) {
      case 1: // Low Stock
        filtered = filtered.where((product) {
          final currentStock = (product['currentStock'] as num?)?.toInt() ?? 0;
          final reorderPoint = (product['reorderPoint'] as num?)?.toInt() ?? 0;
          return currentStock <= reorderPoint;
        }).toList();
        break;
      case 2: // Near Expiry
        filtered = filtered.where((product) {
          final expiryDate = product['expiryDate'] != null
              ? DateTime.tryParse(product['expiryDate'].toString())
              : null;
          if (expiryDate == null) return false;
          final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
          return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
        }).toList();
        break;
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProductDetailsSheet(product),
    );
  }

  Widget _buildProductDetailsSheet(Map<String, dynamic> product) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentStock = (product['currentStock'] as num?)?.toInt() ?? 0;
    final reorderPoint = (product['reorderPoint'] as num?)?.toInt() ?? 0;
    final expiryDate = product['expiryDate'] != null
        ? DateTime.tryParse(product['expiryDate'].toString())
        : null;

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
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image and basic info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'medication',
                              color: colorScheme.primary,
                              size: 12.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name']?.toString() ??
                                  'Unknown Product'.tr,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '${'Lot:'.tr} ${product['lotNumber']?.toString() ?? 'N/A'.tr}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Stock information
                  _buildDetailSection(
                    theme,
                    colorScheme,
                    'Stock Information'.tr,
                    [
                      _buildDetailRow(
                          'Current Stock'.tr, '$currentStock ${'units'.tr}'),
                      _buildDetailRow(
                          'Reorder Point'.tr, '$reorderPoint ${'units'.tr}'),
                      _buildDetailRow('Unit Price'.tr,
                          '\$${(product['unitPrice'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
                      _buildDetailRow('Total Value'.tr,
                          '\$${((product['unitPrice'] as num? ?? 0) * currentStock).toStringAsFixed(2)}'),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Product information
                  _buildDetailSection(
                    theme,
                    colorScheme,
                    'Product Information'.tr,
                    [
                      _buildDetailRow('Category'.tr,
                          product['category']?.toString() ?? 'N/A'.tr),
                      _buildDetailRow('Supplier'.tr,
                          product['supplier']?.toString() ?? 'N/A'.tr),
                      if (expiryDate != null)
                        _buildDetailRow('Expiry Date'.tr,
                            '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}'),
                    ],
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
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
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _reorderProduct(product);
                    },
                    child: Text('Reorder'.tr),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(ThemeData theme, ColorScheme colorScheme,
      String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
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
      builder: (context) => StockAdjustmentSheet(
        product: product,
        onAdjustmentSubmitted: (adjustmentData) {
          _processStockAdjustment(adjustmentData);
        },
      ),
    );
  }

  void _processStockAdjustment(Map<String, dynamic> adjustmentData) {
    final productId = adjustmentData['productId'];
    final adjustmentType = adjustmentData['adjustmentType'];
    final quantity = adjustmentData['quantity'] as int;

    // Find and update the product
    final productIndex = _allProducts.indexWhere((p) => p['id'] == productId);
    if (productIndex != -1) {
      final currentStock =
          (_allProducts[productIndex]['currentStock'] as num).toInt();
      final newStock = adjustmentType == 'Add'
          ? currentStock + quantity
          : currentStock - quantity;

      setState(() {
        _allProducts[productIndex]['currentStock'] = newStock.clamp(0, 99999);
      });

      _applyFilters();

      _showSnackBar("Stock adjusted successfully".tr);
    }
  }

  void _reorderProduct(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    _showSnackBar("${"Reorder request submitted for".tr} ${product['name']}");
  }

  void _markProductExpired(Map<String, dynamic> product) {
    final productIndex =
        _allProducts.indexWhere((p) => p['id'] == product['id']);
    if (productIndex != -1) {
      setState(() {
        _allProducts[productIndex]['expiryDate'] =
            DateTime.now().subtract(Duration(days: 1)).toIso8601String();
      });

      _applyFilters();

      _showSnackBar("Product marked as expired".tr);
    }
  }

  void _showProductContextMenu(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'swap_horiz',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Transfer Between Locations'.tr),
              onTap: () {
                Navigator.pop(context);
                _transferProduct(product);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('View Transaction History'.tr),
              onTap: () {
                Navigator.pop(context);
                _viewTransactionHistory(product);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Set Alerts'.tr),
              onTap: () {
                Navigator.pop(context);
                _setProductAlerts(product);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _transferProduct(Map<String, dynamic> product) {
    _showSnackBar("Transfer functionality would be implemented here".tr);
  }

  void _viewTransactionHistory(Map<String, dynamic> product) {
    _showSnackBar("${"Transaction history for".tr} ${product['name']}");
  }

  void _setProductAlerts(Map<String, dynamic> product) {
    _showSnackBar("${"Alert settings for".tr} ${product['name']}");
  }

  StockController stockController = Get.put(StockController());
///////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Stock Management'.tr,
        actions: [
          IconButton(
            onPressed: stockController.refreshStock,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
            tooltip: 'Refresh Stock'.tr,
          ),
        ],
      ),
      body: Column(
        children: [
          StockSearchBar(
            onSearchChanged: (query) {
              stockController.results.clear();
              stockController.search(query.trim());
            },
            onScanPressed: () {
              showBarcodeScannerBottomSheet(
                onScanned: (code) {
                  stockController.searchController.text = code;
                  stockController.search(code);
                },
              );
            },
          ),
          CustomTabBar(
            isScrollable: true,
            tabs: stockController.tabs,
            controller: _tabController,
            onTap: (index) {
              _applyFilters();
            },
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingView(theme, colorScheme)
                : RefreshIndicator(
                    onRefresh: stockController.refreshStock,
                    child: _filteredProducts.isEmpty
                        ? _buildEmptyView(theme, colorScheme)
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 10.h),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return ProductCard(
                                product: product,
                                onTap: () => _showProductDetails(product),
                                onAdjustStock: () =>
                                    _showStockAdjustmentSheet(product),
                                onReorder: () => _reorderProduct(product),
                                onMarkExpired: () =>
                                    _markProductExpired(product),
                                onLongPress: () =>
                                    _showProductContextMenu(product),
                              );
                            },
                          ),
                  ),
          ),
        ],
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
            'Loading Stock...'.tr,
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
        ],
      ),
    );
  }
}
