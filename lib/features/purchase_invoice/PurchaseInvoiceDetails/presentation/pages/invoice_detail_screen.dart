import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

import 'widgets/product_item_card.dart';
import 'widgets/supplier_info_card.dart';

class InvoiceDetailScreen extends StatefulWidget {
  const InvoiceDetailScreen({super.key});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen>
     {
  late ScrollController _scrollController;
  bool _isRefreshing = false;
  Map<String, dynamic>? _invoiceData;

  // Mock invoice data
  final Map<String, dynamic> mockInvoiceData = {
    "invoiceNumber": "INV-2025-001",
    "supplierName": "Global Tech Supplies Ltd.",
    "supplierPhone": "+1 (555) 123-4567",
    "supplierEmail": "orders@globaltechsupplies.com",
    "supplierAddress": "123 Business Park, Tech City, TC 12345",
    "date": "08/10/2025",
    "currency": "\$",
    "totalAmount": 2847.50,
    "exchangeRate": 1.0,
    "status": "paid",
    "canEdit": false,
    "items": [
      {
        "productName": "Wireless Bluetooth Headphones",
        "productCode": "WBH-2024-001",
        "quantityReceived": 25,
        "freeQuantity": 2,
        "actualPrice": 45.99,
        "totalAmount": 1149.75,
        "expiryDate": "12/31/2026",
        "stockLevel": "high",
        "batchNumber": "BT240810001",
        "manufacturer": "AudioTech Solutions"
      },
      {
        "productName": "USB-C Charging Cables (3ft)",
        "productCode": "USC-3FT-001",
        "quantityReceived": 50,
        "freeQuantity": 5,
        "actualPrice": 12.99,
        "totalAmount": 649.50,
        "expiryDate": "N/A",
        "stockLevel": "medium",
        "batchNumber": "CB240810002",
        "manufacturer": "ConnectPro"
      },
      {
        "productName": "Portable Power Bank 10000mAh",
        "productCode": "PPB-10K-001",
        "quantityReceived": 15,
        "freeQuantity": 1,
        "actualPrice": 29.99,
        "totalAmount": 449.85,
        "expiryDate": "06/30/2027",
        "stockLevel": "low",
        "batchNumber": "PB240810003",
        "manufacturer": "PowerMax Industries"
      },
      {
        "productName": "Wireless Mouse with RGB Lighting",
        "productCode": "WM-RGB-001",
        "quantityReceived": 20,
        "freeQuantity": 0,
        "actualPrice": 24.99,
        "totalAmount": 499.80,
        "expiryDate": "N/A",
        "stockLevel": "high",
        "batchNumber": "MS240810004",
        "manufacturer": "GamerTech"
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _invoiceData = mockInvoiceData;
  }

  @override
  void dispose() {
    _scrollController.dispose();
  
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();
    

    // Simulate API call to refresh invoice data
    await Future.delayed(const Duration(milliseconds: 1500));

    // Update invoice status or sync latest changes
    setState(() {
      _invoiceData = Map<String, dynamic>.from(mockInvoiceData);
      _isRefreshing = false;
    });

   

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice updated successfully'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_invoiceData == null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Invoice Details',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final items = (_invoiceData!["items"] as List<dynamic>?) ?? [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Invoice Details',
              style: Theme.of(context).textTheme.titleLarge),
          actions: [
            IconButton(
                icon: CustomIconWidget(
                  iconName: 'edit',
                  size: 24,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primaryDark
                      : AppColors.primaryLight,
                ),
                onPressed: () {
                  Get.toNamed(AppPages.editPurchaseInvoice);
                }),
          ]),
      body: Column(
        children: [
          // Main Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Supplier Information Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: SupplierInfoCard(invoiceData: _invoiceData!),
                    ),
                  ),

                  // Items Section Header
                  SliverToBoxAdapter(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'inventory_2',
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Items (${items.length})',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Tap to expand',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Product Items List
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index] as Map<String, dynamic>;
                        return ProductItemCard(
                          productData: item,
                          index: index,
                        );
                      },
                      childCount: items.length,
                    ),
                  ),

                  // Bottom Spacing
                  SliverToBoxAdapter(
                    child: SizedBox(height: 10.h),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons Section
        ],
      ),
    );
  }
}
