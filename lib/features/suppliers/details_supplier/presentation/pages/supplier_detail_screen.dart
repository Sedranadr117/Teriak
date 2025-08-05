import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

import './widgets/address_section_card.dart';
import './widgets/financial_overview_card.dart';
import './widgets/financial_records_card.dart';
import './widgets/supplier_header_card.dart';

class SupplierDetailScreen extends StatefulWidget {
  const SupplierDetailScreen({super.key});

  @override
  State<SupplierDetailScreen> createState() => _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends State<SupplierDetailScreen> {
  bool _isLoading = false;

  // Mock supplier data - in real app this would come from arguments or API
  final Map<String, dynamic> supplierData = {
    "id": 1,
    "name": "Ahmed Electronics Supply Co.",
    "phone": "+963 11 234 5678",
    "address": "Damascus Technology Park, Building A, Floor 3, Damascus, Syria",
    "preferredCurrency": "USD",
    "totalPayments": 15750.00,
    "totalDebts": 3200.00,
    "email": "contact@ahmedelectronics.sy",
    "contactPerson": "Ahmed Al-Rashid",
    "establishedDate": "2018-03-15",
    "category": "Electronics & Technology",
    "status": "active",
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context),
      body: _isLoading
          ? _buildLoadingState(context)
          : RefreshIndicator(
              onRefresh: _refreshSupplierData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h),
                    SupplierHeaderCard(supplier: supplierData),
                    FinancialOverviewCard(supplier: supplierData),
                    AddressSectionCard(supplier: supplierData),
                    FinancialRecordsCard(supplier: supplierData),
                    SizedBox(height: 2.h),
                    _buildActionButtons(context),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: colorScheme.onSurface,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        supplierData["name"] as String,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'edit',
            color: colorScheme.primary,
            size: 24,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/edit-supplier-screen');
          },
        ),
        PopupMenuButton<String>(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: colorScheme.onSurface,
            size: 24,
          ),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'share',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'share',
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Share Supplier',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'content_copy',
                    color: colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Duplicate',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'delete',
                    color: colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Delete Supplier',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            "Loading supplier details...",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleContactAction('call'),
                  icon: CustomIconWidget(
                    iconName: 'phone',
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text(
                    "Call Supplier",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _handleContactAction('message'),
                  icon: CustomIconWidget(
                    iconName: 'message',
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  label: Text(
                    "Send Message",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _handleContactAction('copy'),
              icon: CustomIconWidget(
                iconName: 'content_copy',
                color: colorScheme.primary,
                size: 20,
              ),
              label: Text(
                "Copy Contact Information",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshSupplierData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Supplier data refreshed"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        _shareSupplier();
        break;
      case 'duplicate':
        _duplicateSupplier();
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _shareSupplier() {
    final supplierInfo = """
Supplier Information:
Name: ${supplierData["name"]}
Phone: ${supplierData["phone"]}
Address: ${supplierData["address"]}
Currency: ${supplierData["preferredCurrency"]}
Total Payments: ${supplierData["totalPayments"]} ${supplierData["preferredCurrency"]}
Total Debts: ${supplierData["totalDebts"]} ${supplierData["preferredCurrency"]}
""";

    Clipboard.setData(ClipboardData(text: supplierInfo));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Supplier information copied to clipboard"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _duplicateSupplier() {
    Navigator.pushNamed(context, '/add-supplier-screen');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Supplier DetailsSupplier ready for duplication"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteConfirmation() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Supplier',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${supplierData["name"]}"? This action cannot be undone and will remove all associated financial records.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to supplier list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Supplier deleted successfully"),
                  backgroundColor: colorScheme.error,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            child: Text(
              'Delete',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleContactAction(String action) {
    final phone = supplierData["phone"] as String;
    final name = supplierData["name"] as String;

    switch (action) {
      case 'call':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Calling $phone..."),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'message':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Opening messages for $name..."),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'copy':
        final contactInfo = "Name: $name\nPhone: $phone";
        Clipboard.setData(ClipboardData(text: contactInfo));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Contact information copied to clipboard"),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }
}
