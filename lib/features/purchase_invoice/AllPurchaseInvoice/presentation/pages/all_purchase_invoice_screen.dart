import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';
import '../controller/all_purchase_invoice_controller.dart';
import '../widgets/purchase_order_selection_widget.dart';
import '../widgets/invoices_list_widget.dart';

class AllPurchaseInvoiceScreen extends StatefulWidget {
  const AllPurchaseInvoiceScreen({super.key});

  @override
  State<AllPurchaseInvoiceScreen> createState() =>
      _AllPurchaseInvoiceScreenState();
}

class _AllPurchaseInvoiceScreenState extends State<AllPurchaseInvoiceScreen> {
  final controller = Get.find<AllPurchaseInvoiceController>();
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
      appBar: AppBar(
        title: Text(
          'Purchase Invoice Management'.tr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Purchase Order Selection Section
          PurchaseOrderSelectionWidget(),

          SizedBox(height: 2.h),

          // Invoices List Section
          Expanded(
            child: InvoicesListWidget(
              scrollController: _scrollController,
            ),
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
                      'Total: ${controller.totalElements.value} invoices'.tr,
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
    );
  }
}
