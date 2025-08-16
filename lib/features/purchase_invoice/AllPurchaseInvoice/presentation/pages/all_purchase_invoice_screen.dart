import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/presentation/controller/all_purchase_order_controller.dart';
import '../controller/all_purchase_invoice_controller.dart';
import 'widgets/purchase_order_selection_widget.dart';
import 'widgets/invoices_list_widget.dart';

class AllPurchaseInvoiceScreen extends StatefulWidget {
  const AllPurchaseInvoiceScreen({super.key});

  @override
  State<AllPurchaseInvoiceScreen> createState() =>
      _AllPurchaseInvoiceScreenState();
}

class _AllPurchaseInvoiceScreenState extends State<AllPurchaseInvoiceScreen> {
  final controller = Get.put(AllPurchaseInvoiceController());
  final orderController = Get.put(GetAllPurchaseOrderController());

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
          // Purchase Order Selection Section
          SizedBox(height: 1.h),
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
                      '${'Total'.tr}: ${controller.totalElements.value} ${'invoices'.tr}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${'Page'.tr} ${controller.currentPage.value + 1} ${'of'.tr} ${controller.totalPages.value}',
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
