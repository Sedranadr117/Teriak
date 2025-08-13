import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

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
  Map<int, int> _selectedItems = {}; // productId -> selectedQuantity
  bool _isLoading = false;

  // Mock invoice data
  final Map<String, dynamic> _invoiceData = {
    "invoiceNumber": "INV-2024-001",
    "date": "Aug 09, 2024",
    "customerName": "Sarah Johnson",
    "customerPhone": "+1 (555) 123-4567",
    "paymentMethod": "Insurance",
    "paymentStatus": "Paid",
    "outstandingBalance": 0.0,
    "subtotal": 156.75,
    "tax": 12.54,
    "discount": 5.00,
    "total": 164.29,
    "lastSynced": "2024-08-09 18:25:00",
  };

  final List<Map<String, dynamic>> _products = [
    {
      "id": 1,
      "name": "Amoxicillin 500mg Capsules",
      "quantity": 30,
      "unitPrice": 2.50,
      "returnableQuantity": 25,
      "image":
          "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 2,
      "name": "Ibuprofen 200mg Tablets",
      "quantity": 60,
      "unitPrice": 1.25,
      "returnableQuantity": 60,
      "image":
          "https://images.pexels.com/photos/3683056/pexels-photo-3683056.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 3,
      "name": "Vitamin D3 1000 IU Softgels",
      "quantity": 90,
      "unitPrice": 0.35,
      "returnableQuantity": 0,
      "image":
          "https://images.pexels.com/photos/3683098/pexels-photo-3683098.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 4,
      "name": "Lisinopril 10mg Tablets",
      "quantity": 30,
      "unitPrice": 1.80,
      "returnableQuantity": 15,
      "image":
          "https://images.pexels.com/photos/3683089/pexels-photo-3683089.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
    {
      "id": 5,
      "name": "Metformin 500mg Extended Release",
      "quantity": 60,
      "unitPrice": 0.95,
      "returnableQuantity": 45,
      "image":
          "https://images.pexels.com/photos/3683101/pexels-photo-3683101.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadInvoiceData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInvoiceData() async {
    setState(() => _isLoading = true);

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
      bottomNavigationBar: _buildStickyReturnButton(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        'Invoice #${_invoiceData["invoiceNumber"]}',
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
        IconButton(
          icon: CustomIconWidget(
            iconName: 'share',
            color: colorScheme.onPrimary,
            size: 6.w,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            _shareInvoice();
          },
          tooltip: 'Share Invoice',
        ),
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
              value: 'email',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'email',
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF212121)
                        : const Color(0xFFFFFFFF),
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Email'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'copy',
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF212121)
                        : const Color(0xFFFFFFFF),
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  const Text('Duplicate'),
                ],
              ),
            ),
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
              bottom: 20.h, // Extra space for sticky button
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
                      'Items (${_products.length})',
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
              ..._products.map((product) => ProductItemCard(
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
              product["name"] ?? "Unknown Product",
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

  void _shareInvoice() {
    _showSnackBar('Sharing invoice #${_invoiceData["invoiceNumber"]}');
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'print':
        _showSnackBar('Printing invoice #${_invoiceData["invoiceNumber"]}');
        break;
      case 'email':
        _showSnackBar('Emailing invoice #${_invoiceData["invoiceNumber"]}');
        break;
      case 'duplicate':
        _showSnackBar('Duplicating invoice #${_invoiceData["invoiceNumber"]}');
        break;
    }
  }

  void _processReturn() {
    if (_selectedItems.isEmpty) return;

    // Calculate return details
    final selectedProducts = _products
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
