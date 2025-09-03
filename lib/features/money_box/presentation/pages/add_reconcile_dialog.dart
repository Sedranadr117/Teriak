import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/money_box/presentation/controller/add_money_box_reconcile_controlller.dart';
import 'package:teriak/features/money_box/presentation/controller/get_money_box_controlller.dart';

class AddReconcileDialog extends StatelessWidget {
  const AddReconcileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddMoneyBoxReconcileController());

    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: AppColors.primaryLight,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'Reconcile Money Box'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                ),
          ),
        ],
      ),
      content: Container(
        width: 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Actual Amount Field
            TextFormField(
              controller: controller.actualAmountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Actual Amount'.tr,
                hintText: 'Enter actual cash count'.tr,
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.primaryLight, width: 2),
                ),
              ),
              onChanged: (value) => controller.clearError(),
            ),
            SizedBox(height: 3.h),

            // Notes Field
            TextFormField(
              controller: controller.notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes'.tr,
                hintText: 'Enter reconciliation notes'.tr,
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.primaryLight, width: 2),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Error Message
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    controller.errorMessage.value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                );
              }
              return SizedBox.shrink();
            }),
          ],
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            controller.clearForm();
            Get.back();
          },
          child: Text(
            'Cancel'.tr,
            style: TextStyle(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),

        // Reconcile Button
        Obx(() {
          return ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () async {
                    await controller.addReconcile();
                    if (controller.errorMessage.value.isEmpty) {
                      Get.back();
                      // Refresh the money box data
                      final moneyBoxController =
                          Get.find<GetMoneyBoxController>();
                      moneyBoxController.refreshData();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.textPrimaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
            child: controller.isLoading.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textPrimaryLight),
                    ),
                  )
                : Text(
                    'Reconcile'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
          );
        }),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
