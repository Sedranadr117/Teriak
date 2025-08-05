import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const HeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        // TODO: Implement notifications
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('لا توجد إشعارات جديدة')),
                        );
                      },
                      icon: Stack(
                        children: [
                          CustomIconWidget(
                            iconName: 'notifications_outlined',
                            color: theme.colorScheme.onPrimary,
                            size: 24,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.errorLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.onPrimary,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onThemeToggle,
                      icon: CustomIconWidget(
                        iconName: isDarkMode ? 'light_mode' : 'dark_mode',
                        color: theme.colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildStatsRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: 'receipt_long',
            value: '24',
            label: 'إجمالي الطلبات',
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: 'pending_actions',
            value: '8',
            label: 'معلقة',
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: 'check_circle',
            value: '16',
            label: 'مكتملة',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String icon,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.onPrimary,
            size: 20,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
