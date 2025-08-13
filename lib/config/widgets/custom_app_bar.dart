import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// Factory constructor for invoice list screen
  factory CustomAppBar.invoiceList(BuildContext context) {
    return CustomAppBar(
      title: 'Invoice Management',
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Navigate to search functionality
            _showSearchOverlay(context);
          },
          tooltip: 'Search Invoices',
        ),
      ],
    );
  }

  /// Factory constructor for invoice detail screen
  factory CustomAppBar.invoiceDetail(
      BuildContext context, String invoiceNumber) {
    return CustomAppBar(
      title: 'Invoice #$invoiceNumber',
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Share invoice functionality
            _shareInvoice(context, invoiceNumber);
          },
          tooltip: 'Share Invoice',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            HapticFeedback.lightImpact();
            _handleInvoiceMenuAction(context, value, invoiceNumber);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'print',
              child: Row(
                children: [
                  Icon(Icons.print),
                  SizedBox(width: 8),
                  Text('Print'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'email',
              child: Row(
                children: [
                  Icon(Icons.email),
                  SizedBox(width: 8),
                  Text('Email'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.copy),
                  SizedBox(width: 8),
                  Text('Duplicate'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Factory constructor for return processing screen
  factory CustomAppBar.returnProcessing(BuildContext context) {
    return CustomAppBar(
      title: 'Process Return',
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Show help for return processing
            _showReturnHelp(context);
          },
          tooltip: 'Help',
        ),
      ],
    );
  }

  /// Factory constructor for return history screen
  factory CustomAppBar.returnHistory(BuildContext context) {
    return CustomAppBar(
      title: 'Return History',
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Show date range picker
            _showDateRangePicker(context);
          },
          tooltip: 'Date Range',
        ),
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Export return history
            _exportReturnHistory(context);
          },
          tooltip: 'Export',
        ),
      ],
    );
  }

  /// Shows search overlay for invoice search
  static void _showSearchOverlay(BuildContext context) {
    showSearch(
      context: context,
      delegate: _InvoiceSearchDelegate(),
    );
  }

  /// Shows filter options bottom sheet

  /// Shares invoice functionality
  static void _shareInvoice(BuildContext context, String invoiceNumber) {
    // Implementation for sharing invoice
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing invoice #$invoiceNumber'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handles invoice menu actions
  static void _handleInvoiceMenuAction(
      BuildContext context, String action, String invoiceNumber) {
    switch (action) {
      case 'print':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Printing invoice #$invoiceNumber'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'email':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Emailing invoice #$invoiceNumber'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Duplicating invoice #$invoiceNumber'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
    }
  }

  /// Shows help for return processing
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
  static void _exportReturnHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exporting return history...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Custom search delegate for invoice search
class _InvoiceSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implementation for search results
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implementation for search suggestions
    return ListView(
      children: [
        ListTile(
          title: const Text('Recent searches'),
          subtitle: const Text('INV-2024-001'),
          onTap: () {
            query = 'INV-2024-001';
            showResults(context);
          },
        ),
        ListTile(
          title: const Text('Popular searches'),
          subtitle: const Text('Today\'s invoices'),
          onTap: () {
            query = 'today';
            showResults(context);
          },
        ),
      ],
    );
  }
}
