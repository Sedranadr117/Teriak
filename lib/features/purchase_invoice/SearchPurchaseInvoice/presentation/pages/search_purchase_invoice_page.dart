import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/presentation/controller/search_purchase_invoice_controller.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/presentation/pages/search_section.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/presentation/pages/widgets/invoice_card_widget.dart';

class SearchPurchaseInvoicePage extends StatefulWidget {
  const SearchPurchaseInvoicePage({super.key});

  @override
  State<SearchPurchaseInvoicePage> createState() =>
      _SearchPurchaseInvoicePageState();
}

class _SearchPurchaseInvoicePageState extends State<SearchPurchaseInvoicePage> {
  final supplierController = Get.find<GetAllSupplierController>();
  final searchController = Get.put(SearchPurchaseInvoiceController());
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
      searchController.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar:  AppBar(
          title: Text('Search Purchase Invoice'.tr,
              style: Theme.of(context).textTheme.titleLarge),
       ),
      body: Column(
        children: [
          SizedBox(height: 2.h),
          SearchSection(
            suppliers: supplierController.suppliers.cast(),
            onSupplierSelected: searchController.selectSupplier,
            selectedSupplier: searchController.selectedSupplier.value,
            errorText: searchController.searchError.value.isNotEmpty
                ? searchController.searchError.value
                : null,
            searchController: searchController,
          ),
          SizedBox(height: 2.h),

          // Clear Search Button (when search results are shown)
          Obx(() {
            if (searchController.hasSearchResults.value) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: ElevatedButton.icon(
                  onPressed: () => searchController.resetSearch(),
                  icon: Icon(Icons.clear_all, size: 16.sp),
                  label: Text('Clear search'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.grey.shade700,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          SizedBox(height: 2.h),

          // Search Results or Empty State
          Expanded(
            child: Obx(() {
              if (searchController.hasSearchResults.value) {
                return _buildSearchResults();
              } else {
                return _buildEmptyState();
              }
            }),
          ),

          // Pagination Info
          Obx(() {
            if (searchController.hasSearchResults.value) {
              if (searchController.totalElements.value > 0) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${searchController.totalElements.value} invoices'
                            .tr,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Page ${searchController.currentPage.value + 1} of ${searchController.totalPages.value}'
                            .tr,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (searchController.isSearching.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchController.searchError.value.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Text(
              searchController.searchError.value,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () => searchController.resetSearch(),
              child: Text('Clear Search'.tr),
            ),
          ],
        ),
      );
    }

    if (searchController.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No search results found'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () => searchController.resetSearch(),
              child: Text('Clear search'.tr),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: RefreshIndicator(
        onRefresh: () async {
          if (searchController.selectedSupplier.value != null) {
            await searchController.searchBySupplier();
          } else if (searchController.startDate.value != null &&
              searchController.endDate.value != null) {
            await searchController.searchByDateRange();
          }
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: searchController.searchResults.length +
              (searchController.hasNext.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == searchController.searchResults.length) {
              return Obx(() {
                if (searchController.isSearching.value) {
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
      
            final invoice = searchController.searchResults[index] as PurchaseInvoiceModel;
            return InvoiceCardWidget(
              invoice: invoice,
              onTap: () {
                // Navigate to invoice details
                // Get.toNamed(AppPages.purchaseInvoiceDetail, arguments: {'id': invoice.id});
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 2.h),
          Text(
            'Search for Purchase Invoices'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Use the search form above to find invoices by supplier or date range'
                .tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
