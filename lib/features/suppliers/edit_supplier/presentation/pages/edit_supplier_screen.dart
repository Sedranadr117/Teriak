import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

import './widgets/edit_supplier_form_widget.dart';
import './widgets/edit_supplier_header_widget.dart';

class EditSupplierScreen extends StatefulWidget {
  const EditSupplierScreen({super.key});

  @override
  State<EditSupplierScreen> createState() => _EditSupplierScreenState();
}

class _EditSupplierScreenState extends State<EditSupplierScreen> {
  late Map<String, dynamic> supplierData;

  // Mock supplier data - in real app this would come from arguments or state management
  final Map<String, dynamic> mockSupplierData = {
    "id": 1,
    "name": "Global Tech Solutions",
    "phone": "+1-555-0123",
    "address": "1234 Technology Drive, Silicon Valley, CA 94025, USA",
    "preferredCurrency": "USD",
    "totalPayments": 125000.0,
    "totalDebts": 15000.0,
    "lastPaymentDate": "2025-07-28",
    "status": "Active",
    "contactPerson": "Sarah Johnson",
    "email": "sarah.johnson@globaltechsolutions.com",
    "website": "www.globaltechsolutions.com",
    "taxId": "TAX-123456789",
    "paymentTerms": "Net 30",
    "category": "Technology",
    "rating": 4.8,
    "joinDate": "2023-03-15",
    "lastModified": "2025-08-04T18:30:00.000Z",
  };

  @override
  void initState() {
    super.initState();
    supplierData = Map<String, dynamic>.from(mockSupplierData);
  }

  void _handleSave(Map<String, dynamic> updatedData) {
    // Trigger haptic feedback
    HapticFeedback.lightImpact();

    // Show success toast
    Fluttertoast.showToast(
      msg: "Supplier updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Theme.of(context).colorScheme.onPrimary,
    );

    // Navigate back to supplier detail screen
    Navigator.pop(context, updatedData);
  }

  void _handleCancel() {
    Navigator.pop(context);
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Supplier',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete "${supplierData['name']}"? This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to detail screen
              Navigator.pop(context); // Go back to list screen

              Fluttertoast.showToast(
                msg: "Supplier deleted successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Theme.of(context).colorScheme.error,
                textColor: Theme.of(context).colorScheme.onError,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Edit Supplier',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: _handleCancel,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: colorScheme.onSurface,
              size: 24,
            ),
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _showDeleteDialog();
                  break;
                case 'duplicate':
                  Navigator.pushNamed(context, '/add-supplier-screen');
                  break;
              }
            },
            itemBuilder: (context) => [
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
                    const Text('Duplicate'),
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
                      'Delete',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Widget
              EditSupplierHeaderWidget(
                supplierData: supplierData,
              ),

              // Form Widget
              EditSupplierFormWidget(
                supplierData: supplierData,
                onSave: _handleSave,
                onCancel: _handleCancel,
              ),

              SizedBox(height: 2.h),

              // Additional Info Card
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info_outline',
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Additional Information',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    _buildInfoRow(
                      'Supplier ID',
                      '#${supplierData['id']}',
                      theme,
                    ),
                    _buildInfoRow(
                      'Join Date',
                      supplierData['joinDate'] ?? 'N/A',
                      theme,
                    ),
                    _buildInfoRow(
                      'Last Modified',
                      _formatDate(supplierData['lastModified']),
                      theme,
                    ),
                    _buildInfoRow(
                      'Status',
                      supplierData['status'] ?? 'Active',
                      theme,
                      isStatus: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme,
      {bool isStatus = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          isStatus
              ? Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    value,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
