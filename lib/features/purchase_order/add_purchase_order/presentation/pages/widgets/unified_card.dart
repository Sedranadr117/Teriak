import 'package:flutter/material.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class UnifiedCard extends StatelessWidget {
  final String iconName;
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;

  const UnifiedCard({
    super.key,
    required this.iconName,
    required this.title,
    required this.children,
    this.padding,
    this.margin,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin ??
          EdgeInsets.symmetric(
            horizontal: context.w * 0.04,
            vertical: context.h * 0.01,
          ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: showBorder
            ? Border(
                left: BorderSide(
                  color:
                      isDark ? AppColors.primaryDark : AppColors.primaryLight,
                  width: 4.0,
                ),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.shadowDark.withValues(alpha: 0.05)
                : AppColors.shadowLight.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color:
                      isDark ? AppColors.primaryDark : AppColors.primaryLight,
                  size: 20,
                ),
                SizedBox(width: context.w * 0.02),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                      ),
                ),
              ],
            ),
            SizedBox(height: context.h * 0.015),
            ...children,
          ],
        ),
      ),
    );
  }
}

class UnifiedDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemText;
  final void Function(T?) onChanged;
  final String? errorText;
  final bool isExpanded;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;

  const UnifiedDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemText,
    required this.onChanged,
    this.errorText,
    this.isExpanded = true,
    this.prefixIcon,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter out duplicate items based on their value
    final uniqueItems = _getUniqueItems(items);

    // Ensure the selected value exists in the items list
    final validValue = _getValidValue(value, uniqueItems);

    return Container(
      width: isExpanded ? double.infinity : null,
      decoration: BoxDecoration(
        border: Border.all(
          color: errorText != null
              ? (isDark ? AppColors.errorDark : AppColors.errorLight)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        borderRadius: BorderRadius.circular(8),
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: validValue,
          hint: Padding(
            padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon!,
                  SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    hint,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          icon: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          isExpanded: isExpanded,
          items: uniqueItems.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Padding(
                padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  itemText(item),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor:
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        ),
      ),
    );
  }

  // Helper method to get unique items
  List<T> _getUniqueItems(List<T> items) {
    final seen = <int>{};
    return items.where((item) {
      final hashCode = item.hashCode;
      if (seen.contains(hashCode)) {
        return false;
      }
      seen.add(hashCode);
      return true;
    }).toList();
  }

  // Helper method to get valid value
  T? _getValidValue(T? value, List<T> items) {
    if (value == null) return null;

    // Check if the value exists in the items list
    final exists = items.any((item) => item == value);
    if (exists) return value;

    // If value doesn't exist, try to find by id (for entities)
    try {
      final found = items.cast<dynamic>().firstWhere(
            (item) => item.id == (value as dynamic).id,
            orElse: () => null,
          );
      if (found != null) return found as T;
    } catch (e) {
      // If casting fails, just return null
      return null;
    }

    return null;
  }
}

class UnifiedErrorText extends StatelessWidget {
  final String errorText;
  final double? fontSize;

  const UnifiedErrorText({
    super.key,
    required this.errorText,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      errorText,
      style: TextStyle(
        color: isDark ? AppColors.errorDark : AppColors.errorLight,
        fontSize: fontSize ?? 12,
      ),
    );
  }
}
