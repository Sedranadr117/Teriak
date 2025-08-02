import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_assets.dart';
import 'package:teriak/config/themes/app_icon.dart';

class IndebtedCustomerCard extends StatelessWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onTap;
  final VoidCallback onAddPayment;
  final VoidCallback onSendReminder;
  final VoidCallback onCall;

  const IndebtedCustomerCard({
    super.key,
    required this.customer,
    required this.onTap,
    required this.onAddPayment,
    required this.onSendReminder,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double totalDebt = (customer['totalDebt'] as num?)?.toDouble() ?? 0.0;
    final bool isOverdue = customer['isOverdue'] as bool? ?? false;
    final int daysPastDue = (customer['daysPastDue'] as num?)?.toInt() ?? 0;
    final DateTime? dueDate =
        DateTime.tryParse(customer['dueDate'] as String? ?? '');

    return Dismissible(
      key: Key(customer['id'].toString()),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right - add payment
          onAddPayment();
        } else {
          // Swipe left - view details
          onTap();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getBorderColor(colorScheme, isOverdue),
              width: isOverdue ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                offset: Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileImage(colorScheme),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  customer['name']?.toString() ??
                                      'Unknown Customer',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isOverdue)
                                _buildStatusBadge(
                                  theme,
                                  'OVERDUE',
                                  colorScheme.error,
                                  colorScheme.onError,
                                ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            customer['phone']?.toString() ?? 'No phone',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            customer['email']?.toString() ?? 'No email',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDebtInfo(theme, colorScheme, totalDebt),
                    _buildLastPaymentInfo(theme, colorScheme),
                  ],
                ),
                if (dueDate != null) ...[
                  SizedBox(height: 1.h),
                  _buildDueDateInfo(
                      theme, colorScheme, dueDate, isOverdue, daysPastDue),
                ],
                SizedBox(height: 2.h),
                _buildActionButtons(theme, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(ColorScheme colorScheme) {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: customer['profileImage'] != null
            ? Image.asset(Assets.assetsImagesJustLogo)
            : Center(
                child: CustomIconWidget(
                  iconName: 'person',
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 8.w,
                ),
              ),
      ),
    );
  }

  Widget _buildStatusBadge(
      ThemeData theme, String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 8.sp,
        ),
      ),
    );
  }

  Widget _buildDebtInfo(
      ThemeData theme, ColorScheme colorScheme, double totalDebt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Debt',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          '\$${totalDebt.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: totalDebt > 0 ? colorScheme.error : colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildLastPaymentInfo(ThemeData theme, ColorScheme colorScheme) {
    final lastPayment = customer['lastPayment'] as String?;
    final paymentDate =
        lastPayment != null ? DateTime.tryParse(lastPayment) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Last Payment',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          paymentDate != null
              ? '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}'
              : 'No payments',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDueDateInfo(ThemeData theme, ColorScheme colorScheme,
      DateTime dueDate, bool isOverdue, int daysPastDue) {
    final now = DateTime.now();
    final daysUntilDue = dueDate.difference(now).inDays;

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'schedule',
          color: isOverdue
              ? colorScheme.error
              : daysUntilDue <= 7
                  ? Colors.orange
                  : colorScheme.onSurface.withValues(alpha: 0.6),
          size: 4.w,
        ),
        SizedBox(width: 2.w),
        Text(
          isOverdue
              ? 'Overdue by $daysPastDue days'
              : daysUntilDue <= 7
                  ? 'Due in $daysUntilDue days'
                  : 'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isOverdue
                ? colorScheme.error
                : daysUntilDue <= 7
                    ? Colors.orange
                    : colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: isOverdue || daysUntilDue <= 7
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: OutlinedButton(
            onPressed: onAddPayment,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              side: BorderSide(color: colorScheme.primary, width: 1),
            ),
            child: Text(
              'Add Payment',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: OutlinedButton(
            onPressed: onCall,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              side: BorderSide(color: colorScheme.outline, width: 1),
            ),
            child: CustomIconWidget(
              iconName: 'call',
              color: colorScheme.onSurface,
              size: 4.w,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: OutlinedButton(
            onPressed: onSendReminder,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              side: BorderSide(color: colorScheme.outline, width: 1),
            ),
            child: CustomIconWidget(
              iconName: 'notifications',
              color: colorScheme.onSurface,
              size: 4.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft ? colorScheme.primary : Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'payment' : 'visibility',
                color: Colors.white,
                size: 8.w,
              ),
              SizedBox(height: 1.h),
              Text(
                isLeft ? 'Payment' : 'Details',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBorderColor(ColorScheme colorScheme, bool isOverdue) {
    if (isOverdue) return colorScheme.error;
    return colorScheme.outline.withValues(alpha: 0.2);
  }
}
