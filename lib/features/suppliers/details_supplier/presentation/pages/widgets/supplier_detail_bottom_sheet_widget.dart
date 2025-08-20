import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/presentation/controller/search_purchase_invoice_controller.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/financial_overview_card.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/financial_records_card.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_action_widget.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_header_widget.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_info_widget.dart';

class SupplierDetailBottomSheetWidget extends StatefulWidget {
  final SupplierModel supplier;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SupplierDetailBottomSheetWidget({
    super.key,
    required this.supplier,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<SupplierDetailBottomSheetWidget> createState() =>
      _SupplierDetailBottomSheetWidgetState();
}

class _SupplierDetailBottomSheetWidgetState
    extends State<SupplierDetailBottomSheetWidget> {
  late final SearchPurchaseInvoiceController _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController = Get.find<SearchPurchaseInvoiceController>();
    _searchController.selectSupplier(widget.supplier);
    _loadSupplierInvoices();
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
      _searchController.loadNextPage();
    }
  }

  Future<void> _loadSupplierInvoices() async {
    await _searchController.searchBySupplier();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          SupplierHeaderWidget(
            name: widget.supplier.name,
            preferredCurrency: widget.supplier.preferredCurrency,
          ),
          SupplierInfoWidget(
            title: 'Contact Information'.tr,
            children: [
              SupplierInfoRow(
                iconName: 'phone',
                label: 'Phone'.tr,
                value: widget.supplier.phone,
              ),
              SupplierInfoRow(
                iconName: 'location_on',
                label: 'Address'.tr,
                value: widget.supplier.address,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // FinancialOverviewCard(supplier: widget.supplier),
          // SizedBox(height: 2.h),
          // FinancialRecordsCard(supplier: widget.supplier),
          _buildSupplierInvoicesSection(context),
          SizedBox(height: 2.h),
          SupplierActionsWidget(
            onEdit: widget.onEdit,
            onDelete: widget.onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierInvoicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: AppColors.primaryLight,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Supplier Invoices'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Obx(() {
          if (_searchController.isSearchingSupplier.value &&
              _searchController.searchResults.isEmpty) {
            return _buildLoadingState(context);
          }

          if (_searchController.searchError.isNotEmpty) {
            return _buildErrorState(context);
          }

          if (_searchController.searchResults.isEmpty) {
            return _buildEmptyState(context);
          }

          return _buildInvoicesList(context);
        }),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      height: 20.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      height: 20.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 32,
            ),
            SizedBox(height: 2.h),
            Text(
              'Error Loading Invoices'.tr,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchController.searchError.value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: _loadSupplierInvoices,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade700,
              ),
              child: Text('Retry'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 20.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'No Invoices Found'.tr,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'This supplier has no purchase invoices yet.'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoicesList(BuildContext context) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Invoice n'.tr,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date'.tr,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total'.tr,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'items'.tr,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          // Invoices List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadSupplierInvoices,
              child: ListView.separated(
                controller: _scrollController,
                itemCount: _searchController.searchResults.length +
                    (_searchController.hasNext.value ? 1 : 0),
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  if (index == _searchController.searchResults.length) {
                    return Obx(() {
                      if (_searchController.isSearchingSupplier.value) {
                        return Container(
                          padding: EdgeInsets.all(4.w),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    });
                  }

                  final invoice = _searchController.searchResults[index];
                  return _buildInvoiceCard(context, invoice);
                },
              ),
            ),
          ),
          // Pagination Info
          Obx(() {
            if (_searchController.totalElements.value > 0) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${_searchController.totalElements.value} invoices'
                          .tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                    ),
                    Text(
                      'Page ${_searchController.currentPage.value + 1} of ${_searchController.totalPages.value}'
                          .tr,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context, dynamic invoice) {
    final theme = Theme.of(context);
    final createdAt = _parseDate(invoice.createdAt);
    final totalItems = invoice.items.length;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber ?? 'N/A',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              createdAt,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${invoice.currency} ${NumberFormat('#,##0.00').format(invoice.total)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$totalItems',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _parseDate(List<int> dateList) {
    if (dateList.length >= 3) {
      final year = dateList[0];
      final month = dateList[1];
      final day = dateList[2];
      return '$day/$month/$year';
    }
    return 'N/A';
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(top: 1.h),
      width: 12.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
