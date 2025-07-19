import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/master_product/presentation/pages/product_details/widget/product_details-body.dart';
import 'package:teriak/features/master_product/presentation/pages/product_details/widget/product_details_header.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? drugData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

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
        title: Text('Product Details'.tr,
            style: Theme.of(context)
                .textTheme
                .titleLarge /*?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryLight,
              ),*/
            ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15, left: 15),
            child: CustomIconWidget(
              iconName: 'edit',
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.primaryDark
                  : AppColors.primaryLight,
              size: 20,
            ),
          ),
        ],
      ),
      body: drugData == null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: context.h * 0.2,
                    margin: EdgeInsets.all(context.w * 0.04),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  ...List.generate(
                    3,
                    (index) => Container(
                      width: double.infinity,
                      height: context.h * 0.15,
                      margin: EdgeInsets.symmetric(
                          horizontal: context.w * 0.04,
                          vertical: context.w * 0.02),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ProductDetailsHeader(drugData: drugData),
                  SizedBox(height: context.w * 0.02),
                  ProductDetailsBody(drugData: drugData)
                ],
              ),
            ),
    );
  }
}
