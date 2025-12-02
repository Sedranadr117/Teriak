import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';

class SyncBarWidget extends StatelessWidget {
  const SyncBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetAllProductController>();

    return Obx(() {
      // Only show if there are pending products or sync is in progress
      if (controller.pendingProductsCount.value == 0 &&
          !controller.isSyncing.value &&
          controller.syncStatusMessage.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: controller.isSyncing.value
              ? Theme.of(context).colorScheme.primaryContainer
              : controller.pendingProductsCount.value > 0
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Sync icon or status icon
            Obx(() {
              if (controller.isSyncing.value) {
                return SizedBox(
                  width: 16.sp,
                  height: 16.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              } else if (controller.pendingProductsCount.value > 0) {
                return Icon(
                  Icons.cloud_upload_outlined,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.secondary,
                );
              } else {
                return Icon(
                  Icons.check_circle_outline,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.primary,
                );
              }
            }),
            SizedBox(width: 3.w),

            // Status message
            Expanded(
              child: Obx(() {
                if (controller.syncStatusMessage.value.isNotEmpty) {
                  return Text(
                    controller.syncStatusMessage.value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: controller.isSyncing.value
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : controller.pendingProductsCount.value > 0
                                  ? Theme.of(context).colorScheme.onSecondaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                } else if (controller.pendingProductsCount.value > 0) {
                  return Text(
                    '${controller.pendingProductsCount.value} pending product(s) waiting to sync'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                }
                return const SizedBox.shrink();
              }),
            ),

            // Manual sync button
            if (controller.pendingProductsCount.value > 0 && !controller.isSyncing.value)
              IconButton(
                icon: Icon(
                  Icons.sync,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => controller.manualSyncPendingProducts(),
                tooltip: 'Sync pending products'.tr,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
          ],
        ),
      );
    });
  }
}

