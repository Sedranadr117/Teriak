import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/suppliers/delete_supplier/presentation/controller/delete_supplier_controller.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_detail_bottom_sheet_widget.dart';

class SupplierDetailBottomSheet {
  static void show({
    required BuildContext context,
    required SupplierModel supplier,
  }) {
    final supplierController = Get.find<GetAllSupplierController>();
    final deleteController = Get.find<DeleteSupplierController>();
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
            onEdit: () {
               Get.back();
              Get.toNamed(
                AppPages.editSupplier,
                arguments: supplier,
              );
            },
            onDelete: () async {
              await deleteController.deleteSupplier(supplier.id);
              supplierController.suppliers
                  .removeWhere((s) => s.id == supplier.id);
            },
          ),
        ),
      ),
    );
  }
}
