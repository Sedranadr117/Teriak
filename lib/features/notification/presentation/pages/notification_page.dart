import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/notification/domain/entities/notification_entity.dart';
import 'package:teriak/features/notification/presentation/controller/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    
    // Fetch notifications when page is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.notifications.isEmpty) {
        controller.fetchNotifications();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty && controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48.sp,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Error'.tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 1.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    controller.errorMessage.value,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: () => controller.fetchNotifications(),
                  child: Text('Retry'.tr),
                ),
              ],
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64.sp,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                SizedBox(height: 2.h),
                Text(
                  'No Notifications'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'You have no notifications yet'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchNotifications(),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationCard(context, notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationEntity notification) {
    final theme = Theme.of(context);
    final isUnread = notification.status == 'unread' || notification.readAt == null;

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: isUnread ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isUnread
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.onSurface.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(notification.notificationType),
                color: isUnread
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.5),
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                            color: isUnread
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 2.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    notification.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (notification.sentAt != null) ...[
                    SizedBox(height: 1.h),
                    Text(
                      _formatDate(notification.sentAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order':
      case 'purchase_order':
        return Icons.shopping_cart;
      case 'invoice':
      case 'purchase_invoice':
        return Icons.receipt;
      case 'stock':
      case 'inventory':
        return Icons.inventory;
      case 'sale':
        return Icons.point_of_sale;
      case 'payment':
        return Icons.payment;
      case 'alert':
      case 'warning':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now'.tr;
          }
          return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago'.tr;
        }
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago'.tr;
      } else if (difference.inDays == 1) {
        return 'Yesterday'.tr;
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago'.tr;
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}

