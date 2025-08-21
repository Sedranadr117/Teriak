import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/sales_management/presentation/controllers/sale_controller.dart';
import 'package:teriak/features/sales_management/presentation/widgets/search_bar_widget.dart';
import '../widgets/invoice_card_widget.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen>
    with TickerProviderStateMixin {
  // Controllers
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  late SaleController saleController;

  // State variables
  final Map<String, dynamic> _activeFilters = {};
  final List<String> _activeFilterChips = [];
  // ignore: unused_field
  final bool _isRefreshing = false;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    saleController = Get.put(SaleController(customerTag: 'invoice_list'),
        tag: 'invoice_list');
    saleController.fetchAllInvoices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onInvoiceTap(Map<String, dynamic> invoice) {
    HapticFeedback.lightImpact();
    Get.offNamed(AppPages.showInvoicesDitails);
  }

  void _onInvoiceLongPress(Map<String, dynamic> invoice) {
    HapticFeedback.mediumImpact();
    _showInvoiceQuickActions(invoice);
  }

  void _showInvoiceQuickActions(Map<String, dynamic> invoice) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Invoice ${invoice['invoiceNumber']}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'visibility',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _onInvoiceTap(invoice);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'assignment_return',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Process Return'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/return-processing-screen',
                  arguments: invoice,
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Share Invoice'),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar('', "Sharing invoice ${invoice['invoiceNumber']}");
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Invoice Management'.tr),
        actions: [
          IconButton(
            onPressed: saleController.refreshData,
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
          SearchBarWidget(
            controller: saleController.searchController,
            focusNode: saleController.searchFocusNode,
            onChanged: (String) {},
            onBarcodeScanned: () {},
            results: const [],
            isSearching: false,
            itemBuilder: (product) => ListTile(
              title: Text(product.tradeName),
            ),
            onItemTap: (item) {},
            hintText: 'Search invoices by...'.tr,
            isScanner: false,
          ),

          // Invoice list
          Expanded(
            child: Obx(() => _buildInvoiceList()),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList() {
    if (saleController.isLoading.value && saleController.invoices.isEmpty) {
      return _buildLoadingState();
    }

    if (saleController.invoices.isEmpty && !saleController.isLoading.value) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: saleController.refreshData,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: saleController.invoices.length +
            (saleController.isLoading.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= saleController.invoices.length) {
            return _buildLoadingIndicator();
          }
          final invoiceData = saleController.invoices;
          final invoice = invoiceData[index];
          return InvoiceCardWidget(
            invoice: {
              'id': invoice.id,
              'customerId': invoice.customerId,
              'customerName': invoice.customerName,
              'invoiceDate': invoice.invoiceDate,
              'totalAmount': invoice.totalAmount,
              'paymentType': invoice.paymentType,
              'paymentMethod': invoice.paymentMethod,
              'currency': invoice.currency,
              'discount': invoice.discount,
              'discountType': invoice.discountType,
              'paidAmount': invoice.paidAmount,
              'remainingAmount': invoice.remainingAmount,
              'status': invoice.status,
              'items': (invoice.items as List<InvoiceItemModel>)
                  .map((item) => item.toJson())
                  .toList(),
            },
            onTap: () => _onInvoiceTap(
              {
                'id': invoice.id,
                'customerId': invoice.customerId,
                'customerName': invoice.customerName,
                'invoiceDate': invoice.invoiceDate,
                'totalAmount': invoice.totalAmount,
                'paymentType': invoice.paymentType,
                'paymentMethod': invoice.paymentMethod,
                'currency': invoice.currency,
                'discount': invoice.discount,
                'discountType': invoice.discountType,
                'paidAmount': invoice.paidAmount,
                'remainingAmount': invoice.remainingAmount,
                'status': invoice.status,
                'items': (invoice.items as List<InvoiceItemModel>)
                    .map((item) => item.toJson())
                    .toList(),
              },
            ),
            onLongPress: () => _onInvoiceLongPress(
              {
                'id': invoice.id,
                'customerId': invoice.customerId,
                'customerName': invoice.customerName,
                'invoiceDate': invoice.invoiceDate,
                'totalAmount': invoice.totalAmount,
                'paymentType': invoice.paymentType,
                'paymentMethod': invoice.paymentMethod,
                'currency': invoice.currency,
                'discount': invoice.discount,
                'discountType': invoice.discountType,
                'paidAmount': invoice.paidAmount,
                'remainingAmount': invoice.remainingAmount,
                'status': invoice.status,
                'items': (invoice.items as List<InvoiceItemModel>)
                    .map((item) => item.toJson())
                    .toList(),
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading invoices...'.tr,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                  ? 'No invoices found'.tr
                  : 'No invoices available'.tr,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                  ? 'Try adjusting your search or filters'.tr
                  : 'Invoices will appear here when available'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty || _activeFilters.isNotEmpty) ...[
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                    _activeFilters.clear();
                    _activeFilterChips.clear();
                  });
                },
                child: Text('Clear Filters'.tr),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
