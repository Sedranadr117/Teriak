import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/widgets/custom_binding_widget.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/widget/add_product_button.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/pages/widgets/supplier_bottomsheet_widget.dart';
import 'package:teriak/features/suppliers/delete_supplier/presentation/controller/delete_supplier_controller.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_detail_bottom_sheet_widget.dart';
import 'package:teriak/features/suppliers/search_supplier/presentation/controller/search_supplier_controller.dart';
import 'package:teriak/features/suppliers/search_supplier/presentation/pages/search_bar.dart';
import './widgets/supplier_card_widget.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final supplierController = Get.put(GetAllSupplierController());
  final searchController = Get.put(SearchSupplierController());
  final deleteController = Get.put(DeleteSupplierController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Supplier Management',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SearchWidget(),
              Expanded(
                child: Obx(() {
                  final status = searchController.searchStatus.value;

                  if (status == null) {
                    if (supplierController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (supplierController.errorMessage.value.isNotEmpty) {
                      return CommonWidgets.buildErrorWidget(
                        context: context,
                        errorMessage: supplierController.errorMessage.value,
                        title: 'Error Suppliers Loading',
                      );
                    }

                    if (supplierController.suppliers.isEmpty) {
                      return Center(child: Text("لايوجد موردين"));
                    }

                    return RefreshIndicator(
                      onRefresh: supplierController.refreshSuppliers,
                      color: colorScheme.primary,
                      child: ListView(
                        controller: searchController.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 1.h,
                          bottom: 10.h,
                        ),
                        children: [
                          ...supplierController.suppliers.map(
                            (supplier) => SupplierCardWidget(
                              supplier: supplier,
                              onTap: () => SupplierDetailBottomSheet.show(
                                context: context,
                                supplier: supplier,
                              ),
                              onEdit: () {
                                Get.toNamed(AppPages.editSupplier,
                                    arguments: supplier);
                              },
                                onDelete: () async {
                              await deleteController
                                  .deleteSupplier(supplier.id);
                              supplierController.suppliers
                                  .removeWhere((s) => s.id == supplier.id);
                            },
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (status.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (status.isError) {
                    return CommonWidgets.buildErrorWidget(
                      context: context,
                      errorMessage: searchController.errorMessage.value,
                      title: 'Error Searching Suppliers',
                    );
                  }

                  if (status.isEmpty && searchController.results.isEmpty) {
                    return CommonWidgets.buildNoResultsWidget(
                      context: context,
                      onClear: () => searchController.searchController.clear(),
                    );
                  }

                  if (status.isSuccess) {
                    return ListView(
                      controller: searchController.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: 1.h,
                        bottom: 10.h,
                      ),
                      children: [
                        ...searchController.results.map(
                          (supplier) => SupplierCardWidget(
                            supplier: supplier,
                            onTap: () => SupplierDetailBottomSheet.show(
                              context: context,
                              supplier: supplier,
                            ),
                            onEdit: () {
                              Get.toNamed(AppPages.editSupplier,
                                  arguments: supplier);
                            },
                            onDelete: () async {
                              await deleteController
                                  .deleteSupplier(supplier.id);
                              supplierController.suppliers
                                  .removeWhere((s) => s.id == supplier.id);
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: AddButton(
          onTap: () {
            Get.toNamed(AppPages.addSupplier);
          },
          label: 'Add Supplier',
        ));
  }
}
