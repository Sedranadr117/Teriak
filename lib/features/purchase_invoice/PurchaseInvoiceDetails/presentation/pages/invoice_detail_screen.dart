import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_item_model.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';
import 'package:teriak/main.dart';

import 'widgets/product_item_card.dart';
import 'widgets/supplier_info_card.dart';

class PurchaseInvoiceDetailScreen extends StatefulWidget {
  const PurchaseInvoiceDetailScreen({super.key});

  @override
  State<PurchaseInvoiceDetailScreen> createState() =>
      _PurchaseInvoiceDetailScreenState();
}

class _PurchaseInvoiceDetailScreenState
    extends State<PurchaseInvoiceDetailScreen> {
  late ScrollController _scrollController;
  late PurchaseInvoiceModel invoiceItem;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    invoiceItem = Get.arguments as PurchaseInvoiceModel;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // if (invoiceItem == null) {
    //   return Scaffold(
    //     resizeToAvoidBottomInset: false,
    //     appBar: AppBar(
    //       title: Text('Invoice Details'.tr,
    //           style: Theme.of(context).textTheme.titleLarge),
    //     ),
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('Invoice Details'.tr,
              style: Theme.of(context).textTheme.titleLarge),
          actions: [
            (role == "PHARMACY_MANAGER")
                ? Container()
                : IconButton(
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      size: 24,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                    ),
                    onPressed: () {
                      // Get.toNamed(AppPages.editPurchaseInvoice);
                    }),
          ]),
      body: Column(
        children: [
          // Main Content
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Supplier Information Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: SupplierInfoCard(invoiceData: invoiceItem),
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
                          '${'Items'.tr} (${invoiceItem.items.length})',
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
                            'Tap to expand'.tr,
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
                      final item =
                          invoiceItem.items[index] as PurchaseInvoiceItemModel;
                      return ProductItemCard(
                        productData: item,
                        index: index,
                      );
                    },
                    childCount: invoiceItem.items.length,
                  ),
                ),

                // Bottom Spacing
                SliverToBoxAdapter(
                  child: SizedBox(height: 10.h),
                ),
              ],
            ),
          ),

          // Action Buttons Section
        ],
      ),
    );
  }
}
