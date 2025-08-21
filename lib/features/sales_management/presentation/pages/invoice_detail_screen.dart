import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/customer_managment/presentation/controllers/customer_controller.dart';
import 'package:teriak/features/sales_management/presentation/controllers/sale_controller.dart';

import '../widgets/invoice_header_card.dart';
import '../widgets/invoice_totals_card.dart';
import '../widgets/product_item_card.dart';
import '../widgets/sticky_return_button.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({super.key});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late ScrollController _scrollController;
  late SaleController saleController;
  late CustomerController customerController;
  late Map<String, dynamic> _invoiceData;
  Map<int, int> _selectedItems = {};
  void initState() {
    super.initState();
    customerController = Get.put(CustomerController());
    saleController = Get.put(SaleController(customerTag: ''));
    _invoiceData = Get.arguments as Map<String, dynamic>;

    customerController.fetchCustomers();
    _scrollController = ScrollController();
    saleController.fetchAllInvoices();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: Obx(
        () => saleController.isLoading.value
            ? _buildLoadingState()
            : _buildContent(),
      ),
      bottomNavigationBar: _buildStickyReturnButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        'Invoice #${_invoiceData["customerName"]}',
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
      ),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 2,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: colorScheme.onPrimary,
          size: 6.w,
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
      ),
      actions: [
        PopupMenuButton<String>(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: colorScheme.onPrimary,
            size: 6.w,
          ),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'print',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'print',
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF212121)
                        : const Color(0xFFFFFFFF),
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Print'),
                ],
              ),
            ),
            PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'share',
                      color: theme.brightness == Brightness.light
                          ? const Color(0xFF212121)
                          : const Color(0xFFFFFFFF),
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    const Text('Share'),
                  ],
                ))
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      children: [
        // Header skeleton
        Card(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Container(
            height: 22.h,
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Container(
                  height: 3.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF424242),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  height: 12.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF424242),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product skeletons
        ...List.generate(
            3,
            (index) => Card(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  child: Container(
                    height: 12.h,
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.light
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF424242),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 2.h,
                                width: 70.w,
                                decoration: BoxDecoration(
                                  color: theme.brightness == Brightness.light
                                      ? const Color(0xFFE0E0E0)
                                      : const Color(0xFF424242),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                height: 1.5.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: theme.brightness == Brightness.light
                                      ? const Color(0xFFE0E0E0)
                                      : const Color(0xFF424242),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(
              top: 1.h,
              bottom: 20.h,
            ),
            children: [
              // Invoice header
              InvoiceHeaderCard(invoiceData: _invoiceData),

              // Products section header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    Text(
                      'Items (${_invoiceData['items'].length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    if (_selectedItems.isNotEmpty)
                      TextButton(
                        onPressed: _clearSelection,
                        child: Text(
                          'Clear Selection',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                  ],
                ),
              ),

              // Product list
              ..._invoiceData['items'].map((product) => ProductItemCard(
                    product: product,
                    isSelected: _selectedItems.containsKey(product["id"]),
                    selectedQuantity: _selectedItems[product["id"]] ?? 0,
                    onTap: () => _toggleProductSelection(product),
                    onLongPress: () => _showProductContextMenu(product),
                    onQuantityChanged: (quantity) =>
                        _updateSelectedQuantity(product["id"], quantity),
                  )),

              // Invoice totals
              InvoiceTotalsCard(invoiceData: _invoiceData),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStickyReturnButton() {
    final selectedItemsCount = _selectedItems.values.fold<int>(
      0,
      (sum, quantity) => sum + (quantity > 0 ? 1 : 0),
    );

    return StickyReturnButton(
      selectedItemsCount: selectedItemsCount,
      isEnabled: selectedItemsCount > 0,
      onPressed: _processReturn,
    );
  }

  void _toggleProductSelection(Map<String, dynamic> product) {
    final int productId = product["id"];
    final int returnableQty = product["returnableQuantity"] as int? ?? 0;

    if (returnableQty == 0) {
      _showSnackBar('This item cannot be returned');
      return;
    }

    setState(() {
      if (_selectedItems.containsKey(productId)) {
        _selectedItems.remove(productId);
      } else {
        _selectedItems[productId] = 1;
      }
    });

    HapticFeedback.selectionClick();
  }

  void _updateSelectedQuantity(int productId, int quantity) {
    setState(() {
      if (quantity <= 0) {
        _selectedItems.remove(productId);
      } else {
        _selectedItems[productId] = quantity;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
    });
    HapticFeedback.lightImpact();
    _showSnackBar('Selection cleared');
  }

  void _showProductContextMenu(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['productName'] ?? "Unknown Product",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('View Product Details'),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Product details feature coming soon');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'inventory',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Check Inventory'),
              onTap: () {
                Navigator.pop(context);
                _showSnackBar('Inventory check feature coming soon');
              },
            ),
            if ((product["returnableQuantity"] as int? ?? 0) > 0)
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'assignment_return',
                  color: Theme.of(context).colorScheme.primary,
                  size: 6.w,
                ),
                title: const Text('Return Item'),
                onTap: () {
                  Navigator.pop(context);
                  _toggleProductSelection(product);
                },
              ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'print':
        _showSnackBar('Printing invoice #${_invoiceData["invoiceNumber"]}');
        break;
      case 'share':
        _showSnackBar('Sharing invoice #${_invoiceData["invoiceNumber"]}');
        break;
    }
  }

  void _processReturn() {
    if (_selectedItems.isEmpty) return;

    // Calculate return details
    final selectedProducts = _invoiceData['items']
        .where((product) => _selectedItems.containsKey(product["id"]))
        .toList();

    double totalReturnAmount = 0.0;
    for (final product in selectedProducts) {
      final quantity = _selectedItems[product["id"]] ?? 0;
      final unitPrice = product["unitPrice"] as double? ?? 0.0;
      totalReturnAmount += quantity * unitPrice;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Return'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Return ${_selectedItems.length} item${_selectedItems.length == 1 ? '' : 's'}?'),
            SizedBox(height: 1.h),
            Text(
              'Estimated refund: \$${totalReturnAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                '/return-processing-screen',
                arguments: {
                  'invoiceData': _invoiceData,
                  'selectedItems': _selectedItems,
                  'products': selectedProducts,
                },
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
