import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class SupplierDetailBottomSheetWidget extends StatelessWidget {
  final Map<String, dynamic> supplier;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetPreferred;
  final VoidCallback onViewOrders;

  const SupplierDetailBottomSheetWidget({
    super.key,
    required this.supplier,
    required this.onEdit,
    required this.onDelete,
    required this.onSetPreferred,
    required this.onViewOrders,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          _buildHeader(context),
          _buildContent(context),
          _buildActions(context),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(top: 1.h),
      width: 12.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                (supplier['name'] as String).substring(0, 1).toUpperCase(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                        supplier['name'] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'account_balance_wallet',
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "Preferred Currency: ${supplier["preferredCurrency"] as String}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          _buildInfoSection(context, 'Contact Information', [
            _buildInfoRow(
                context, 'phone', 'Phone', supplier['phone'] as String),
            _buildInfoRow(context, 'location_on', 'Address',
                supplier['address'] as String),
          ]),
          // SizedBox(height: 2.h),
          // _buildInfoSection(context, 'Business Information', [
          //   _buildInfoRow(context, 'business', 'Category',
          //       supplier['category'] as String),
          //   _buildInfoRow(context, 'payment', 'Payment Terms',
          //       supplier['paymentTerms'] as String),
          //   _buildInfoRow(context, 'local_shipping', 'Delivery Time',
          //       supplier['deliveryTime'] as String),
          // ]),
          // SizedBox(height: 2.h),
          // _buildOrderSummary(context),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String iconName, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: theme.colorScheme.primary,
            size: 16.sp,
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
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final theme = Theme.of(context);
    final orderCount = supplier['recentOrderCount'] as int? ?? 0;
    final totalValue = supplier['totalOrderValue'] as String? ?? '\$0';
    final lastOrderDate = supplier['lastOrderDate'] as String? ?? 'Never';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order History',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                    context, 'receipt_long', 'Total Orders', '$orderCount'),
              ),
              Expanded(
                child: _buildStatItem(
                    context, 'attach_money', 'Total Value', totalValue),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildStatItem(context, 'schedule', 'Last Order', lastOrderDate),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context, String iconName, String label, String value) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.primary,
          size: 16.sp,
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final isPreferred = supplier['isPreferred'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: theme.colorScheme.primary,
                    size: 16.sp,
                  ),
                  label: const Text('Edit'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSetPreferred,
                  icon: CustomIconWidget(
                    iconName: isPreferred ? 'star' : 'star_border',
                    color: theme.colorScheme.primary,
                    size: 16.sp,
                  ),
                  label: Text(isPreferred ? 'Remove' : 'Preferred'),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onViewOrders,
                  icon: CustomIconWidget(
                    iconName: 'receipt_long',
                    color: theme.colorScheme.onPrimary,
                    size: 16.sp,
                  ),
                  label: const Text('View Orders'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: CustomIconWidget(
                    iconName: 'delete',
                    color: theme.colorScheme.error,
                    size: 16.sp,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
