import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/purchase_invoice/AddPurchaseInvoice/presentation/pages/widgets/product_search_bar_widget.dart';

class InvoiceHeaderWidget extends StatelessWidget {
  final TextEditingController invoiceNumberController;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function(String) onBarcodeScanned;
  final VoidCallback onInvoiceNumberChanged;

  const InvoiceHeaderWidget({
    super.key,
    required this.invoiceNumberController,
    required this.searchController,
    required this.onSearchChanged,
    required this.onBarcodeScanned,
    required this.onInvoiceNumberChanged,
  });

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
            controller: searchController,
            onChanged: onSearchChanged,
            onBarcodeScanned: onBarcodeScanned,
          ),

          SizedBox(height: 2.h),

          // Invoice Number
          TextFormField(
            controller: invoiceNumberController,
            decoration: InputDecoration(
              labelText: 'رقم الفاتورة *',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'receipt_long',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'رقم الفاتورة مطلوب';
              }
              return null;
            },
            onChanged: (value) => onInvoiceNumberChanged(),
          ),
        ],
      ),
    );
  }
}
