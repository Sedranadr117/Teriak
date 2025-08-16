import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/presentation/controller/search_purchase_invoice_controller.dart';

class SearchSection extends StatefulWidget {
  final List<SupplierModel> suppliers;
  final Function(SupplierModel) onSupplierSelected;
  final SupplierModel? selectedSupplier;
  final String? errorText;
  final SearchPurchaseInvoiceController searchController;

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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Purchase Invoice'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          SizedBox(height: 2.h),

          // Supplier Search Section
          _buildSupplierSearch(context),
          SizedBox(height: 2.h),

          // Date Range Search Section
          _buildDateRangeSearch(context),
          SizedBox(height: 2.h),

          // Search Buttons
          _buildSearchButtons(context),
          SizedBox(height: 0.3.h),

          // Error Display
          if (widget.errorText != null && widget.errorText!.isNotEmpty)
            _buildErrorText(context, widget.errorText!),
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
        SizedBox(height: 1.h),
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 3.w),
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
                fontSize: 12.sp,
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
            validator: (value) {
              if (widget.searchController.supplierError.value != null) {
                return widget.searchController.supplierError.value;
              }
              return null;
            },
          ),
        ),
        if (widget.searchController.supplierError.value != null)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              widget.searchController.supplierError.value!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 10.sp,
              ),
            ),
          ),
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
        if (widget.searchController.dateError.value != null)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              widget.searchController.dateError.value!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 10.sp,
              ),
            ),
          ),
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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
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
              // Force rebuild to show selected date
              setState(() {});
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 16.sp,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
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
          child: ElevatedButton.icon(
            onPressed: widget.searchController.isSearching.value
                ? null
                : () => widget.searchController.searchBySupplier(),
            icon: widget.searchController.isSearching.value
                ? SizedBox(
                    width: 10.sp,
                    height: 10.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : Icon(Icons.search, size: 10.sp),
            label: Text(
              'Search by Supplier'.tr,
              style: TextStyle(fontSize: 9.sp),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryVariantLight,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.searchController.isSearching.value
                ? null
                : () => widget.searchController.searchByDateRange(),
            icon: widget.searchController.isSearching.value
                ? SizedBox(
                    width: 10.sp,
                    height: 10.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : Icon(Icons.date_range, size: 10.sp),
            label: Text(
              'Search by Date'.tr,
              style: TextStyle(fontSize: 9.sp),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryLight,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
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
