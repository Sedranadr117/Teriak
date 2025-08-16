import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';


import './widgets/invoice_header_widget.dart';
import './widgets/invoice_summary_widget.dart';
import './widgets/product_search_widget.dart';
import './widgets/product_table_widget.dart';

class InvoiceEditing extends StatefulWidget {
  const InvoiceEditing({super.key});

  @override
  State<InvoiceEditing> createState() => _InvoiceEditingState();
}

class _InvoiceEditingState extends State<InvoiceEditing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Original invoice data (simulating loaded data)
  late Map<String, dynamic> _originalInvoiceData;

  // Current invoice data (editable)
  late Map<String, dynamic> _currentInvoiceData;
  late List<Map<String, dynamic>> _currentProducts;

  bool _hasUnsavedChanges = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeInvoiceData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeInvoiceData() {
    // Simulating loaded invoice data
    _originalInvoiceData = {
      'id': 'INV-2024-001',
      'invoiceNumber': 'INV-2024-001',
      'supplier': 'Al-Dawaa Medical Supplies',
      'date': DateTime(2024, 8, 5),
      'totalAmount': 1247.50,
      'status': 'Paid',
      'currency': 'USD',
    };

    _currentInvoiceData = Map<String, dynamic>.from(_originalInvoiceData);

    _currentProducts = [
      {
        'id': 'P001',
        'name': 'Paracetamol 500mg',
        'barcode': '1234567890123',
        'unitPrice': 2.50,
        'requestedQuantity': 100,
        'receivedQuantity': 95,
        'bonusQuantity': 5,
        'batchNumber': 'BATCH001',
        'expirationDate': DateTime(2025, 12, 31),
        'actualPrice': 2.30,
        'category': 'Pain Relief',
        'manufacturer': 'Pharma Co.',
      },
      {
        'id': 'P002',
        'name': 'Amoxicillin 250mg',
        'barcode': '2345678901234',
        'unitPrice': 15.75,
        'requestedQuantity': 50,
        'receivedQuantity': 48,
        'bonusQuantity': 2,
        'batchNumber': 'BATCH002',
        'expirationDate': DateTime(2026, 6, 15),
        'actualPrice': 15.50,
        'category': 'Antibiotics',
        'manufacturer': 'Medical Labs',
      },
      {
        'id': 'P003',
        'name': 'Vitamin D3 1000 IU',
        'barcode': '3456789012345',
        'unitPrice': 8.25,
        'requestedQuantity': 75,
        'receivedQuantity': 75,
        'bonusQuantity': 0,
        'batchNumber': 'BATCH003',
        'expirationDate': DateTime(2025, 9, 30),
        'actualPrice': 8.00,
        'category': 'Vitamins',
        'manufacturer': 'Health Plus',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) {
        if (!didPop && _hasUnsavedChanges) {
          _showUnsavedChangesDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Invoice'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _handleBackNavigation(),
          ),
          actions: [
            if (_hasUnsavedChanges)
              Container(
                margin: EdgeInsets.only(right: 4.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onError.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onError.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: theme.colorScheme.error,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Modified',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view_original',
                  child: Row(
                    children: [
                      Icon(Icons.history),
                      SizedBox(width: 12),
                      Text('View Original'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'reset_changes',
                  child: Row(
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 12),
                      Text('Reset Changes'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(Icons.copy),
                      SizedBox(width: 12),
                      Text('Duplicate Invoice'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // Invoice Header
                      InvoiceHeaderWidget(
                        invoiceData: _currentInvoiceData,
                        onInvoiceNumberChanged: _updateInvoiceNumber,
                        onSupplierChanged: _updateSupplier,
                        onDateChanged: _updateDate,
                      ),

                      // Product Search
                      ProductSearchWidget(
                        onProductSelected: _addProduct,
                        existingProducts: _currentProducts,
                      ),

                      // Product Table
                      ProductTableWidget(
                        products: _currentProducts,
                        onProductUpdated: _updateProduct,
                        onProductRemoved: _removeProduct,
                      ),

                      // Invoice Summary
                      InvoiceSummaryWidget(
                        products: _currentProducts,
                        originalInvoice: _originalInvoiceData,
                        onSaveChanges: _saveChanges,
                        hasChanges: _hasUnsavedChanges,
                      ),

                      SizedBox(height: 10.h), // Bottom padding
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _updateInvoiceNumber(String value) {
    setState(() {
      _currentInvoiceData['invoiceNumber'] = value;
      _hasUnsavedChanges = true;
    });
  }

  void _updateSupplier(String value) {
    setState(() {
      _currentInvoiceData['supplier'] = value;
      _hasUnsavedChanges = true;
    });
  }

  void _updateDate(DateTime value) {
    setState(() {
      _currentInvoiceData['date'] = value;
      _hasUnsavedChanges = true;
    });
  }

  void _addProduct(Map<String, dynamic> product) {
    setState(() {
      final newProduct = Map<String, dynamic>.from(product);
      newProduct.addAll({
        'requestedQuantity': 0,
        'receivedQuantity': 0,
        'bonusQuantity': 0,
        'batchNumber': '',
        'expirationDate': DateTime.now().add(const Duration(days: 365)),
        'actualPrice': product['unitPrice'],
      });
      _currentProducts.add(newProduct);
      _hasUnsavedChanges = true;
    });

    // Auto-scroll to the new product
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _updateProduct(int index, Map<String, dynamic> updatedProduct) {
    setState(() {
      _currentProducts[index] = updatedProduct;
      _hasUnsavedChanges = true;
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _currentProducts.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _showChangeSummaryDialog();
  }

  void _showChangeSummaryDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Changes'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review the changes you made to this invoice:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),

              // Changes Summary
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice: ${_currentInvoiceData['invoiceNumber']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Supplier: ${_currentInvoiceData['supplier']}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Products: ${_currentProducts.length} items',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Total: \$${_calculateTotalAmount().toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              Text(
                'This action will update the invoice record permanently.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              _performSave();
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _performSave() {
    setState(() {
      _isLoading = true;
    });

    // Simulate save operation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasUnsavedChanges = false;
          _originalInvoiceData = Map<String, dynamic>.from(_currentInvoiceData);
          _originalInvoiceData['totalAmount'] = _calculateTotalAmount();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                const Text('Invoice updated successfully'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  double _calculateTotalAmount() {
    return _currentProducts.fold(0.0, (total, product) {
      final receivedQty = product['receivedQuantity'] as int? ?? 0;
      final bonusQty = product['bonusQuantity'] as int? ?? 0;
      final actualPrice = product['actualPrice'] as double? ??
          (product['unitPrice'] as double? ?? 0.0);

      return total + ((receivedQty + bonusQty) * actualPrice);
    });
  }

  void _handleBackNavigation() {
    if (_hasUnsavedChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.pop(context);
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. What would you like to do?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Discard',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              _saveChanges();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    HapticFeedback.lightImpact();

    switch (action) {
      case 'view_original':
        _showOriginalInvoiceDialog();
        break;
      case 'reset_changes':
        _showResetChangesDialog();
        break;
      case 'duplicate':
        Navigator.pushNamed(context, '/invoice-creation');
        break;
    }
  }

  void _showOriginalInvoiceDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Original Invoice'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Original invoice details:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice: ${_originalInvoiceData['invoiceNumber']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Supplier: ${_originalInvoiceData['supplier']}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Date: ${_formatDate(_originalInvoiceData['date'] as DateTime)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Original Total: \$${(_originalInvoiceData['totalAmount'] as double).toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResetChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Changes'),
        content: const Text(
          'This will discard all your changes and restore the original invoice data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              _resetToOriginal();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _resetToOriginal() {
    setState(() {
      _currentInvoiceData = Map<String, dynamic>.from(_originalInvoiceData);
      _initializeInvoiceData(); // Reset products to original
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('Changes reset to original'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
