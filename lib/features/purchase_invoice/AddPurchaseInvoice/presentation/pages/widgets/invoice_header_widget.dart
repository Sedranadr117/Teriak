import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/purchase_invoice/AddPurchaseInvoice/presentation/pages/widgets/product_search_bar_widget.dart';

class InvoiceHeaderWidget extends StatefulWidget {
  final String supplierName;
  final String currency;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final void Function()? onBarcodeScanned;

  const InvoiceHeaderWidget({
    super.key,
    required this.supplierName,
    required this.currency,
    required this.searchController,
    required this.onSearchChanged,
    required this.onBarcodeScanned,
  });

  @override
  State<InvoiceHeaderWidget> createState() => _InvoiceHeaderWidgetState();
}

class _InvoiceHeaderWidgetState extends State<InvoiceHeaderWidget> {
  @override
  void didUpdateWidget(InvoiceHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تحديث الواجهة عند تغيير البيانات
    if (oldWidget.searchController.text != widget.searchController.text) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Search Bar
          ProductSearchBarWidget(
            controller: widget.searchController,
            onChanged: widget.onSearchChanged,
            onBarcodeScanned: widget.onBarcodeScanned,
          ),

          SizedBox(height: 0.5.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purchase Order Data'.tr,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.supplierName,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      widget.currency,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Invoice Number
        ],
      ),
    );
  }
}
