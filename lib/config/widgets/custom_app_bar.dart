import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/themes/theme_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool showThemeToggle;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
    this.showThemeToggle = true,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return AppBar(
      title: Text(title),
      leading: leading,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: [
        if (showThemeToggle)
          Obx(() => IconButton(
                onPressed: () => themeController.toggleTheme(),
                icon: CustomIconWidget(
                  iconName:
                      themeController.isDarkMode ? 'light_mode' : 'dark_mode',
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 24,
                ),
                tooltip: themeController.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              )),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize {
    if (bottom != null) {
      return Size.fromHeight(kToolbarHeight + bottom!.preferredSize.height);
    }
    return const Size.fromHeight(kToolbarHeight);
  }

  /// Shows help for return processing
  // ignore: unused_element
  static void _showReturnHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Return Processing Help'),
        content: const Text(
          'To process a return:\n\n'
          '1. Scan or enter the invoice number\n'
          '2. Select items to return\n'
          '3. Choose return reason\n'
          '4. Confirm the return amount\n'
          '5. Process the refund',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  /// Shows date range picker
  // ignore: unused_element
  static void _showDateRangePicker(BuildContext context) {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    ).then((dateRange) {
      if (dateRange != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Date range: ${dateRange.start.toString().split(' ')[0]} - ${dateRange.end.toString().split(' ')[0]}',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  /// Exports return history
  // ignore: unused_element
  static void _exportReturnHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting return history...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
