import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class CommonWidgets {
  static Widget buildErrorWidget({
    required BuildContext context,
    required String errorMessage,
    String title = 'Error Loading',
    String iconName = 'error',
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: colorScheme.error,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  static Widget buildNoResultsWidget({
    required BuildContext context,
    required VoidCallback onClear,
    String title = 'No Results Found',
    String subtitle = 'no search',
    String iconName = 'search_off',
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: colorScheme.onSurfaceVariant,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              subtitle.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            // OutlinedButton.icon(
            //   onPressed: onClear,
            //   icon: CustomIconWidget(
            //     iconName: 'clear',
            //     color: colorScheme.primary,
            //     size: 5.w,
            //   ),
            //   label: Text(
            //     'Clear Search',
            //     style: theme.textTheme.labelLarge?.copyWith(
            //       color: colorScheme.primary,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            //   style: OutlinedButton.styleFrom(
            //     side: BorderSide(color: colorScheme.primary),
            //     padding: EdgeInsets.symmetric(
            //       horizontal: 6.w,
            //       vertical: 1.5.h,
            //     ),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  static Widget buildRequiredWidget({
    required BuildContext context,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'info',
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'All fields marked with * are required. Make sure to double-check the information before saving.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
