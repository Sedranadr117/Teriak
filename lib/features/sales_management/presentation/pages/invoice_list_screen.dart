import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/sales_management/presentation/controllers/sale_controller.dart';
import '../widgets/invoice_card_widget.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  late SaleController saleController;

  @override
  void initState() {
    super.initState();

    saleController = Get.put(SaleController(customerTag: 'invoice_list'),
        tag: 'invoice_list');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.fetchAllInvoices();
    });
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: saleController.startDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        saleController.startDate.value = picked;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: saleController.endDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        saleController.endDate.value = picked;
      });
    }
  }

  void _onInvoiceTap(Map<String, dynamic> invoice) {
    HapticFeedback.lightImpact();
    Get.toNamed(AppPages.showInvoicesDitails, arguments: invoice);
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
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickStartDate,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        saleController.startDate.value != null
                            ? '${saleController.startDate.value!.day}/${saleController.startDate.value!.month}/${saleController.startDate.value!.year}'
                            : 'Start Date'.tr,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: InkWell(
                    onTap: _pickEndDate,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        saleController.endDate.value != null
                            ? '${saleController.endDate.value!.day}/${saleController.endDate.value!.month}/${saleController.endDate.value!.year}'
                            : 'End Date'.tr,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Obx(() {
                  final active = saleController.isFilterActive.value;
                  return IconButton(
                    onPressed: () async {
                      if (active) {
                        setState(() {
                          saleController.startDate.value = null;
                          saleController.endDate.value = null;
                          saleController.searchResults.clear();
                          saleController.isFilterActive.value = false;
                        });
                        await saleController.fetchAllInvoices();
                      } else {
                        await saleController.searchByDateRange();
                      }
                    },
                    icon: Icon(active ? Icons.close : Icons.search),
                    tooltip: active ? 'Clear Filters'.tr : 'Search'.tr,
                  );
                }),
              ],
            ),
          ),

          // Invoice list
          Expanded(
            child: RefreshIndicator(
                onRefresh: () async {
                  saleController.refreshData();
                },
                child: _buildInvoiceList()),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList() {
    return Obx(() {
      final bool isFiltering = saleController.isFilterActive.value;

      final listToShow =
          isFiltering ? saleController.searchResults : saleController.invoices;

      if ((saleController.isLoading.value && !isFiltering) ||
          (saleController.isSearching.value && isFiltering)) {
        return _buildLoadingState();
      }

      if (listToShow.isEmpty) {
        return _buildEmptyState(isFiltering: isFiltering);
      }

      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listToShow.length,
        itemBuilder: (context, index) {
          if (index >= listToShow.length) {
            return _buildLoadingIndicator();
          }
          final invoice = listToShow[index];
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
              'paymentStatus': invoice.paymentStatus,
              'refundStatus': invoice.refundStatus,
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
                'paymentStatus': invoice.paymentStatus,
                'refundStatus': invoice.refundStatus,
                'items': (invoice.items as List<InvoiceItemModel>)
                    .map((item) => item.toJson())
                    .toList(),
              },
            ),
          );
        },
      );
    });
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

  Widget _buildEmptyState({bool isFiltering = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String messageTitle =
        isFiltering ? 'No invoices found'.tr : 'No invoices available'.tr;
    final String messageBody = isFiltering
        ? 'Try adjusting your search'.tr
        : 'Invoices will appear here when available'.tr;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              messageTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              messageBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            if (isFiltering) ...[
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    saleController.startDate.value = null;
                    saleController.endDate.value = null;
                    saleController.searchResults.clear();
                    saleController.isFilterActive.value = false;
                  });
                  await saleController.fetchAllInvoices();
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
