import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/master_product/presentation/controller/get_allProduct_controller.dart';

class AddProductButton extends StatefulWidget {
  const AddProductButton({super.key});

  @override
  State<AddProductButton> createState() => _AddProductButtonState();
}

class _AddProductButtonState extends State<AddProductButton> {
  final allController = Get.find<GetAllProductController>();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: ()  {
         Get.toNamed(AppPages.addProductPage);
      },
      label: Text(
        'Add Product'.tr,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.onPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
      ),
      icon: const CustomIconWidget(
        iconName: 'add',
        color: AppColors.onPrimaryLight,
        size: 24,
      ),
    );
  }
}
