import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/presentation/controller/all_purchase_order_controller.dart';

class SyncBarWidget extends StatelessWidget {
  const SyncBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetAllPurchaseOrderController>();

    return Obx(() {
      // Only show if sync is in progress or there's a status message
      if (!controller.isSyncing.value && controller.syncStatusMessage.value.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: controller.isSyncing.value
              ? Theme.of(context).colorScheme.primaryContainer
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
            // Sync icon or loading indicator
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
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                }
                return const SizedBox.shrink();
              }),
            ),

            // Manual sync button (always visible when bar is shown)
            if (!controller.isSyncing.value)
              IconButton(
                icon: Icon(
                  Icons.sync,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => controller.manualSyncPurchaseOrders(),
                tooltip: 'Sync purchase orders'.tr,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      );
    });
  }
}

