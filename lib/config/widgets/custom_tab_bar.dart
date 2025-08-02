import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

/// Tab item for CustomTabBar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? child;

  const TabItem({
    required this.label,
    this.icon,
    this.child,
  });
}

/// Custom TabBar widget for healthcare pharmacy application
/// Implements Clinical Efficiency Design with clear visual hierarchy
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<TabItem> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;
  final bool isScrollable;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double? indicatorWeight;
  final TabBarIndicatorSize? indicatorSize;
  final EdgeInsetsGeometry? labelPadding;
  final EdgeInsetsGeometry? indicatorPadding;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight,
    this.indicatorSize,
    this.labelPadding,
    this.indicatorPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        onTap: (index) {
          HapticFeedback.lightImpact();
          onTap?.call(index);
        },
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        labelColor: labelColor ?? colorScheme.primary,
        unselectedLabelColor: unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorWeight: indicatorWeight ?? 3.0,
        indicatorSize: indicatorSize ?? TabBarIndicatorSize.label,
        labelPadding: labelPadding ?? EdgeInsets.symmetric(horizontal: 16),
        indicatorPadding: indicatorPadding ?? EdgeInsets.zero,
        labelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: indicatorColor ?? colorScheme.primary,
            width: indicatorWeight ?? 3.0,
          ),
          insets: indicatorPadding ?? EdgeInsets.zero,
        ),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: tabs.map((tab) => _buildTab(context, tab)).toList(),
      ),
    );
  }

  Widget _buildTab(BuildContext context, TabItem tab) {
    final theme = Theme.of(context);

    return Tab(
      height: 48,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null) ...[
              Icon(
                tab.icon,
                size: 20,
              ),
              SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                tab.label,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48);
}

/// Custom TabBarView wrapper for consistent styling
class CustomTabBarView extends StatelessWidget {
  final List<Widget> children;
  final TabController? controller;
  final DragStartBehavior dragStartBehavior;
  final double? viewportFraction;

  const CustomTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      dragStartBehavior: dragStartBehavior,
      viewportFraction: viewportFraction!,
      children:
          children.map((child) => _buildTabContent(context, child)).toList(),
    );
  }

  Widget _buildTabContent(BuildContext context, Widget child) {
    return Container(
      padding: EdgeInsets.all(16),
      child: child,
    );
  }
}

/// Pharmacy-specific tab configurations
class PharmacyTabs {
  static const List<TabItem> transactionTabs = [
    TabItem(
      label: 'Active',
      icon: Icons.pending_actions,
    ),
    TabItem(
      label: 'Completed',
      icon: Icons.check_circle_outline,
    ),
    TabItem(
      label: 'Pending',
      icon: Icons.schedule,
    ),
  ];

  static const List<TabItem> inventoryTabs = [
    TabItem(
      label: 'Stock',
      icon: Icons.inventory_2_outlined,
    ),
    TabItem(
      label: 'Low Stock',
      icon: Icons.warning_amber_outlined,
    ),
    TabItem(
      label: 'Orders',
      icon: Icons.shopping_cart_outlined,
    ),
  ];

  static const List<TabItem> analyticsTabs = [
    TabItem(
      label: 'Daily',
      icon: Icons.today,
    ),
    TabItem(
      label: 'Weekly',
      icon: Icons.date_range,
    ),
    TabItem(
      label: 'Monthly',
      icon: Icons.calendar_month,
    ),
  ];
}
