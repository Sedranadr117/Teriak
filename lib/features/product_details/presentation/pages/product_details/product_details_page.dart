import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/product_details/presentation/controller/get_product_details_controller.dart';
import 'package:teriak/features/product_details/presentation/pages/product_details/widget/product_details-body.dart';
import 'package:teriak/features/product_details/presentation/pages/product_details/widget/product_details_header.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final detailsController = Get.put(GetProductDetailsController());

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
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppPages.editProductPage,
                        arguments: drugData,
                      );
                    },
                    child: CustomIconWidget(
                      iconName: 'edit',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                      size: 20,
                    ),
                  ),
                if (drugData.productType == "Pharmacy" ||
                    drugData.productType == "صيدلية")
                  CustomIconWidget(
                    iconName: 'delete',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.errorDark
                        : AppColors.errorLight,
                    size: 22,
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
