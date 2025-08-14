import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import '../controller/purchase_order_details_controller.dart';
import 'widgets/simple_product_card.dart';

class PurchaseOrderDetail extends StatefulWidget {
  const PurchaseOrderDetail({super.key});

  @override
  State<PurchaseOrderDetail> createState() => _PurchaseOrderDetailState();
}

class _PurchaseOrderDetailState extends State<PurchaseOrderDetail> {
  final controller = Get.put(PurchaseOrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        if (controller.purchaseOrder.value == null) {
          return _buildNoDataState();
        }

        return _buildContent();
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Purchase Order Details'.tr),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'edit',
            size: 24,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.primaryDark
                : AppColors.primaryLight,
          ),
          onPressed: () {
            if (controller.purchaseOrder.value?.status == "PENDING") {
              Get.toNamed(
                AppPages.editPurchaseOrder,
                arguments: {
                  'order': controller.purchaseOrder.value,
                  'supplierId': controller.supplierId.value,
                },
              );
            } else {
              Get.snackbar('', "لا يمكن تعديل الطلبية في حالتها الحالية",
                  backgroundColor: Colors.red, colorText: Colors.white);
            }
          },
          tooltip: 'Edit Order'.tr,
        ),
        IconButton(
          icon: CustomIconWidget(
            iconName: 'delete',
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.errorDark
                : AppColors.errorLight,
            size: 24,
          ),
          onPressed: () => _showDeleteConfirmation(),
          tooltip: 'Delete Order'.tr,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading order details'.tr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: Theme.of(context).colorScheme.error,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Error'.tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              controller.errorMessage.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () => controller.refreshPurchaseOrderDetails(),
              icon: const CustomIconWidget(
                iconName: 'refresh',
                size: 20,
              ),
              label: Text('Retry'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'receipt_long',
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No purchase orders found'.tr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final order = controller.purchaseOrder.value!;

    return RefreshIndicator(
      onRefresh: controller.refreshPurchaseOrderDetails,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            _buildOrderHeader(order),
            SizedBox(height: 2.h),
            _buildSectionHeader('Products List'.tr),
            _buildProductsList(order),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(dynamic order) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Name
            _buildInfoRow(
              'Supplier'.tr,
              order.supplierName ?? ' '.tr,
              Icons.business,
            ),
            SizedBox(height: 1.h),

            // Order Status
            _buildInfoRow(
              'Order Status'.tr,
              _getStatusText(order.status ?? ' '),
              Icons.info_outline,
              statusColor: _getStatusColor(order.status ?? 'pending'),
            ),
            SizedBox(height: 1.h),

            // Currency
            _buildInfoRow(
              'Currency'.tr,
              order.currency ?? 'SYP',
              Icons.monetization_on,
            ),
            SizedBox(height: 1.h),

            // Total Amount
            _buildInfoRow(
              'Total Amount'.tr,
              _formatAmount(
                  order.total?.toDouble() ?? 0.0, order.currency ?? 'SYP'),
              Icons.attach_money,
              valueColor: AppColors.successLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? statusColor,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color:
              statusColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      valueColor ?? statusColor ?? theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(PurchaseOrderEntity order) {
    final products = order.items;

    if (products.isEmpty) {
      return Card(
        margin: EdgeInsets.all(4.w),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'inventory_2',
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4),
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'No products in this order'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: products.map<Widget>((product) {
        return SimpleProductCard(
          productData: {
            'name': product.productName,
            'quantity': product.quantity,
            'unitPrice': product.price,
            'barcode': product.barcode,
            'type': product.productType,
          },
          currency: order.currency,
        );
      }).toList(),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'PENDING':
        return 'Pending'.tr;
      case 'DONE':
        return 'Completed'.tr;
      case 'CANCELLED ':
        return 'Cancelled'.tr;
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'PENDING':
        return AppColors.warningLight;
      case 'DONE':
        return AppColors.successLight;
      case 'CANCELLED':
        return AppColors.errorLight;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  String _formatAmount(double amount, String currency) {
    final formattedAmount = amount.toStringAsFixed(2);
    return currency == 'USD' ? '\$$formattedAmount' : '$formattedAmount ل.س';
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Delete Order'.tr),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this order? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteOrder();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text('Delete'.tr),
          ),
        ],
      ),
    );
  }

  void _deleteOrder() {
    // سيتم تنفيذ حذف الطلبية لاحقاً
    Get.snackbar(
      'Delete Order'.tr,
      'Order deleted successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.successLight,
      colorText: Colors.white,
    );

    Get.back(); // العودة للصفحة السابقة
  }
}
