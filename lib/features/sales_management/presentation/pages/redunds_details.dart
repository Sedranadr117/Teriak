import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/sales_management/presentation/controllers/sale_controller.dart';

import '../widgets/invoice_header_card.dart';
import '../widgets/product_item_card.dart';

class RefundDetailScreen extends StatefulWidget {
  const RefundDetailScreen({super.key});

  @override
  State<RefundDetailScreen> createState() => _RefundDetailScreenState();
}

class _RefundDetailScreenState extends State<RefundDetailScreen> {
  late ScrollController _scrollController;
  late SaleController saleController;
  late Map<String, dynamic> _invoiceData;
  @override
  void initState() {
    super.initState();
    saleController = Get.put(SaleController(customerTag: ''));
    _invoiceData = Get.arguments as Map<String, dynamic>;

    _scrollController = ScrollController();
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
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        '${'Invoice'.tr} #${_invoiceData["customerName"]}',
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
                      '${'Items'.tr}(${(_invoiceData['refundItems'] ?? []).length})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              // Product list
              ..._invoiceData['refundItems'].map((product) => ProductItemCard(
                    product: product,
                  )),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }
}
