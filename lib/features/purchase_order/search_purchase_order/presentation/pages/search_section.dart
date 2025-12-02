import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/purchase_order/search_purchase_order/presentation/controller/search_purchase_order_controller.dart';

class SearchSection extends StatefulWidget {
  final List<SupplierModel> suppliers;
  final Function(SupplierModel) onSupplierSelected;
  final SupplierModel? selectedSupplier;
  final String? errorText;
  final SearchPurchaseOrderController searchController;

  const SearchSection({
    super.key,
    required this.suppliers,
    required this.onSupplierSelected,
    required this.selectedSupplier,
    this.errorText,
    required this.searchController,
  });

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  void _showSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (innerContext, scrollController) => Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 40.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Search Purchase Orders'.tr,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(bottomSheetContext),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              // Search Options
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Supplier Search Section
                      _buildSupplierSearch(innerContext),
                      SizedBox(height: 2.h),

                      // Date Range Search Section
                      _buildDateRangeSearch(innerContext),
                      SizedBox(height: 2.h),

                      // Search Buttons
                      _buildSearchButtonsForBottomSheet(bottomSheetContext),
                      SizedBox(height: 2.h),

                      // Error Display
                      Obx(() {
                        final error = widget.searchController.searchError.value;
                        if (error.isNotEmpty) {
                          return _buildErrorText(innerContext, error);
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Search Bar
          InkWell(
            onTap: () => _showSearchBottomSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Obx(() {
                      final hasSearch =
                          widget.searchController.hasSearchResults.value;
                      final selectedSupplier = widget.selectedSupplier;
                      final startDate = widget.searchController.startDate.value;
                      final endDate = widget.searchController.endDate.value;

                      String searchText =
                          'Search by supplier or date range...'.tr;

                      if (hasSearch) {
                        if (selectedSupplier != null) {
                          searchText = 'Supplier: ${selectedSupplier.name}';
                        } else if (startDate != null && endDate != null) {
                          searchText =
                              'Date: ${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}';
                        } else if (startDate != null) {
                          searchText =
                              'From: ${startDate.day}/${startDate.month}/${startDate.year}';
                        }
                      }

                      return Text(
                        searchText,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: hasSearch
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.grey.shade600,
                          fontWeight:
                              hasSearch ? FontWeight.w500 : FontWeight.normal,
                        ),
                      );
                    }),
                  ),
                  SizedBox(width: 2.w),
                  Obx(() {
                    if (widget.searchController.hasSearchResults.value) {
                      return InkWell(
                        onTap: () {
                          widget.searchController.resetSearch();
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(1.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.clear,
                            size: 16.sp,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      );
                    }
                    return Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: Colors.grey.shade400,
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierSearch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search by Supplier'.tr,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 0.5.h),
        Obx(() => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.searchController.supplierError.value != null
                      ? Colors.red
                      : Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonFormField<SupplierModel>(
                value: widget.selectedSupplier,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Select Supplier'.tr,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 8.sp,
                  ),
                ),
                items: widget.suppliers.map((supplier) {
                  return DropdownMenuItem<SupplierModel>(
                    value: supplier,
                    child: Text(
                      supplier.name,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  );
                }).toList(),
                onChanged: (SupplierModel? value) {
                  if (value != null) {
                    widget.onSupplierSelected(value);
                  }
                },
              ),
            )),
        Obx(() {
          final error = widget.searchController.supplierError.value;
          if (error != null) {
            return Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10.sp,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildDateRangeSearch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search by Date Range'.tr,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                'Start Date'.tr,
                widget.searchController.startDate.value,
                (date) => widget.searchController.setStartDate(date),
                widget.searchController.dateError.value,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: _buildDateField(
                context,
                'End Date'.tr,
                widget.searchController.endDate.value,
                (date) => widget.searchController.setEndDate(date),
                widget.searchController.dateError.value,
              ),
            ),
          ],
        ),
        Obx(() {
          final error = widget.searchController.dateError.value;
          if (error != null) {
            return Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10.sp,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
    String? errorText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: 0.5.h),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              onDateSelected(date);
              setState(() {});
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: errorText != null
                    ? Colors.red
                    : Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
                      : 'Select Date'.tr,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: selectedDate != null
                        ? Theme.of(context).textTheme.bodyMedium?.color
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.8),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 11.sp,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final isSearching =
                widget.searchController.isSearchingSupplier.value;
            return ElevatedButton.icon(
              onPressed: isSearching
                  ? null
                  : () => widget.searchController.searchBySupplier(),
              icon: isSearching
                  ? SizedBox(
                      width: 11.sp,
                      height: 11.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : Icon(Icons.search, size: 11.sp),
              label: Text(
                isSearching ? 'Searching...'.tr : 'Search by Supplier'.tr,
                style: TextStyle(fontSize: 11.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryVariantLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Obx(() {
            final isSearching = widget.searchController.isSearchingDate.value;
            return ElevatedButton.icon(
              onPressed: isSearching
                  ? null
                  : () => widget.searchController.searchByDateRange(),
              icon: isSearching
                  ? SizedBox(
                      width: 11.sp,
                      height: 11.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : Icon(Icons.date_range, size: 11.sp),
              label: Text(
                isSearching ? 'Searching...'.tr : 'Search by Date'.tr,
                style: TextStyle(fontSize: 11.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSearchButtonsForBottomSheet(BuildContext bottomSheetContext) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final isSearching =
                widget.searchController.isSearchingSupplier.value;
            return ElevatedButton.icon(
              onPressed: isSearching
                  ? null
                  : () async {
                      await widget.searchController.searchBySupplier();
                      if (mounted &&
                          widget.searchController.hasSearchResults.value) {
                        Navigator.pop(bottomSheetContext);
                      }
                    },
              icon: isSearching
                  ? SizedBox(
                      width: 11.sp,
                      height: 11.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : Icon(Icons.search, size: 11.sp),
              label: Text(
                isSearching ? 'Searching...'.tr : 'Search by Supplier'.tr,
                style: TextStyle(fontSize: 11.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryVariantLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Obx(() {
            final isSearching = widget.searchController.isSearchingDate.value;
            return ElevatedButton.icon(
              onPressed: isSearching
                  ? null
                  : () async {
                      await widget.searchController.searchByDateRange();
                      if (mounted &&
                          widget.searchController.hasSearchResults.value) {
                        Navigator.pop(bottomSheetContext);
                      }
                    },
              icon: isSearching
                  ? SizedBox(
                      width: 11.sp,
                      height: 11.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : Icon(Icons.date_range, size: 11.sp),
              label: Text(
                isSearching ? 'Searching...'.tr : 'Search by Date'.tr,
                style: TextStyle(fontSize: 11.sp),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildErrorText(BuildContext context, String error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(1.w),
      margin: EdgeInsets.only(top: 0.5.h),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 12.sp,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
