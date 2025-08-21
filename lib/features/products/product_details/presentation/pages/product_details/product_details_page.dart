import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/products/delete_product/presentation/controller/delete_product_controller.dart';
import 'package:teriak/features/products/product_details/presentation/controller/get_product_details_controller.dart';
import 'package:teriak/features/products/product_details/presentation/pages/product_details/widget/product_details-body.dart';
import 'package:teriak/features/products/product_details/presentation/pages/product_details/widget/product_details_header.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final detailsController = Get.put(GetProductDetailsController());
    final deleteController = Get.put(DeleteProductController());
    final allController = Get.find<GetAllProductController>();

    Future<bool> _showDeleteConfirmation(
        BuildContext context, void Function()? onPressed) async {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Delete Product'.tr),
              content: Text(
                '${"Are you sure you want to delete product".tr}"'.tr,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'.tr),
                ),
                TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text('Delete'.tr),
                ),
              ],
            ),
          ) ??
          false;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.onSurfaceDark
                : AppColors.onSurfaceLight,
            size: 24,
          ),
        ),
        title: Text('Product Details'.tr),
        actions: [
          Obx(() {
            final drugData = detailsController.product.value;
            if (drugData == null) return SizedBox();

            return Row(
              children: [
                if (drugData.productType == "Pharmacy" ||
                    drugData.productType == "صيدلية")
                  IconButton(
                    onPressed: () {
                      print(drugData.productType);
                      Get.toNamed(
                        AppPages.editProductPage,
                        arguments: drugData,
                      );
                    },
                    icon: CustomIconWidget(
                      iconName: 'edit',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                      size: 20,
                    ),
                  ),
                if (drugData.productType == "Pharmacy" ||
                    drugData.productType == "صيدلية")
                  IconButton(
                    onPressed: () async {
                      await _showDeleteConfirmation(context, () {
                        deleteController.deleteProduct(drugData.id);
                        allController.refreshProducts();

                        Navigator.of(context).pop(true);
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'delete',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.errorDark
                          : AppColors.errorLight,
                      size: 22,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Obx(() {
        if (detailsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (detailsController.errorMessage.isNotEmpty) {
          return Center(child: Text(detailsController.errorMessage.value));
        }

        final drugData = detailsController.product.value;
        if (drugData == null) {
          return const Center(child: Text("No data"));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              ProductDetailsHeader(drugData: drugData),
              SizedBox(height: context.w * 0.02),
              ProductDetailsBody(drugData: drugData),
            ],
          ),
        );
      }),
    );
  }
}
