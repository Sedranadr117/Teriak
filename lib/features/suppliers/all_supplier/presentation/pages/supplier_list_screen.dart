import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_detail_bottom_sheet_widget.dart';

import './widgets/empty_state_widget.dart';
import './widgets/search_header_widget.dart';
import './widgets/supplier_card_widget.dart';
import './widgets/supplier_stats_widget.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final GetAllSupplierController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(GetAllSupplierController());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _controller.searchSuppliers(_searchController.text);
  }

  void _navigateToSupplierDetail(Map<String, dynamic> supplier) {
    Get.toNamed(
      AppPages.supplierDetail,
      arguments: supplier,
    );
  }

  void _navigateToAddSupplier() {
    Get.toNamed(AppPages.addSupplier);
  }

  void _navigateToEditSupplier(Map<String, dynamic> supplier) {
    Get.toNamed(
      AppPages.editSupplier,
      arguments: supplier,
    );
  }

  void _deleteSupplier(Map<String, dynamic> supplier) {
    _controller.deleteSupplier(supplier);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${supplier["name"]} deleted successfully'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _controller.addSupplierBack(supplier);
          },
        ),
      ),
    );
  }

  void _showSupplierDetails(Map<String, dynamic> supplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: SupplierDetailBottomSheetWidget(
            supplier: supplier,
            onEdit: () {},
            onDelete: () {},
            onSetPreferred: () {},
            onViewOrders: () {},
          ),
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
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => SearchHeaderWidget(
                  searchController: _searchController,
                  onSearchChanged: (value) =>
                      _controller.searchSuppliers(value),
                  onThemeToggle: _controller.toggleTheme,
                  isDarkMode: _controller.isDarkMode.value,
                )),
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return _buildLoadingWidget();
                }

                if (_controller.errorMessage.value.isNotEmpty) {
                  return _buildErrorWidget();
                }

                if (_controller.filteredSuppliers.isEmpty) {
                  return _controller.isSearchActive
                      ? _buildNoResultsWidget()
                      : EmptyStateWidget(
                          onAddSupplier: _navigateToAddSupplier,
                        );
                }

                return RefreshIndicator(
                  onRefresh: _controller.refreshSuppliers,
                  color: colorScheme.primary,
                  child: ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 1.h,
                      bottom: 10.h, // Space for FAB
                    ),
                    children: [
                      // Statistics Widget
                      if (_controller.suppliers.isNotEmpty)
                        const SupplierStatsWidget(),

                      // Suppliers List
                      ..._controller.filteredSuppliers.map(
                        (supplier) => SupplierCardWidget(
                          supplier: supplier,
                          onTap: () => _showSupplierDetails(supplier),
                          onEdit: () => _navigateToEditSupplier(supplier),
                          onDelete: () => _deleteSupplier(supplier),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddSupplier,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        icon: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 6.w,
        ),
        label: Text(
          'Add Supplier',
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildLoadingWidget() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading suppliers...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'error',
                  color: colorScheme.error,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Error Loading Suppliers',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              _controller.errorMessage.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: _controller.getSuppliers,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text(
                'Retry',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 1.5.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'search_off',
                  color: colorScheme.onSurfaceVariant,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'No Results Found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'No suppliers match your search for "${_controller.searchQuery.value}". Try adjusting your search terms.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                _controller.clearSearch();
              },
              icon: CustomIconWidget(
                iconName: 'clear',
                color: colorScheme.primary,
                size: 5.w,
              ),
              label: Text(
                'Clear Search',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary),
                padding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 1.5.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
