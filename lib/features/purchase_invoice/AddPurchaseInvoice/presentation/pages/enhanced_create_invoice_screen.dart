import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';

import './widgets/invoice_products_table_widget.dart';
import './widgets/product_search_bar_widget.dart';
import './widgets/running_total_widget.dart';

class EnhancedCreateInvoiceScreen extends StatefulWidget {
  const EnhancedCreateInvoiceScreen({super.key});

  @override
  State<EnhancedCreateInvoiceScreen> createState() =>
      _EnhancedCreateInvoiceScreenState();
}

class _EnhancedCreateInvoiceScreenState
    extends State<EnhancedCreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumberController = TextEditingController();
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic>? _purchaseOrder;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String _searchQuery = '';

  // Auto-save functionality
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _generateInvoiceNumber();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPurchaseOrderData();
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
    _invoiceNumberController.text = 'INV-${DateFormat('yyyy')}-$timestamp';
  }

  void _loadPurchaseOrderData() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      setState(() {
        _purchaseOrder = args['purchaseOrder'];
        _products = _generateProductsFromPO(_purchaseOrder!);
      });
    }
  }

  List<Map<String, dynamic>> _generateProductsFromPO(Map<String, dynamic> po) {
    // Mock products data based on PO
    final List<Map<String, dynamic>> mockProducts = [
      {
        "id": "ITEM001",
        "name": "سماعات لاسلكية بتقنية البلوتوث",
        "sku": "WBH-001",
        "barcode": "1234567890123",
        "requiredQuantity": 50,
        "unitPrice": 89.99,
        "receivedQuantity": 0,
        "bonusQuantity": 0,
        "minStockLevel": 10,
        "batchNumber": "",
        "expiryDate": null,
        "actualPurchasePrice": 89.99,
        "isSelected": false,
      },
      {
        "id": "ITEM002",
        "name": "كابل شحن USB-C",
        "sku": "UCC-002",
        "barcode": "1234567890124",
        "requiredQuantity": 100,
        "unitPrice": 12.99,
        "receivedQuantity": 0,
        "bonusQuantity": 0,
        "minStockLevel": 25,
        "batchNumber": "",
        "expiryDate": null,
        "actualPurchasePrice": 12.99,
        "isSelected": false,
      },
      {
        "id": "ITEM003",
        "name": "واقي شاشة للهواتف الذكية",
        "sku": "SSP-003",
        "barcode": "1234567890125",
        "requiredQuantity": 200,
        "unitPrice": 8.99,
        "receivedQuantity": 0,
        "bonusQuantity": 0,
        "minStockLevel": 50,
        "batchNumber": "",
        "expiryDate": null,
        "actualPurchasePrice": 8.99,
        "isSelected": false,
      },
    ];

    return mockProducts;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });

    if (query.isNotEmpty) {
      _scrollToMatchingProduct(query);
    }
  }

  void _scrollToMatchingProduct(String query) {
    for (int i = 0; i < _products.length; i++) {
      final product = _products[i];
      if (product['name'].toLowerCase().contains(query) ||
          product['barcode'].contains(query) ||
          product['sku'].toLowerCase().contains(query)) {
        // Calculate approximate position based on item height
        final position = i * 120.0; // Approximate height per item

        _scrollController.animateTo(position,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
        break;
      }
    }
  }

  void _onBarcodeScanned(String barcode) {
    _searchController.text = barcode;
    _onSearchChanged(barcode);

    // Highlight the found product
    for (int i = 0; i < _products.length; i++) {
      if (_products[i]['barcode'] == barcode) {
        _scrollToMatchingProduct(barcode);

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('تم العثور على المنتج: ${_products[i]['name']}'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            duration: const Duration(seconds: 2)));
        break;
      }
    }
  }

  void _onProductDataChanged(int index, Map<String, dynamic> updatedData) {
    setState(() {
      _products[index] = {..._products[index], ...updatedData};
      _hasUnsavedChanges = true;
    });

    _autoSave();
  }

  void _autoSave() {
    // Implement auto-save functionality
    // This could save to local storage or send periodic updates to server
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (final product in _products) {
      final receivedQty = product['receivedQuantity'] as int;
      final bonusQty = product['bonusQuantity'] as int;
      final actualPrice = product['actualPurchasePrice'] as double;

      if (receivedQty > 0) {
        // Calculate total including bonus adjustment
        final totalQty = receivedQty + bonusQty;
        final unitCost =
            totalQty > 0 ? (receivedQty * actualPrice) / totalQty : actualPrice;
        total += receivedQty * unitCost;
      }
    }
    return total;
  }

  Future<void> _proceedToPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate that at least one product has received quantity
    final hasReceivedProducts =
        _products.any((product) => (product['receivedQuantity'] as int) > 0);

    if (!hasReceivedProducts) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('يجب إدخال الكمية المستلمة لمنتج واحد على الأقل'),
          backgroundColor: Theme.of(context).colorScheme.error));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Simulate API call to save invoice
      await Future.delayed(const Duration(seconds: 2));

      // Show success dialog
      _showPaymentSuccessDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('فشل في حفظ الفاتورة. الرجاء المحاولة مرة أخرى'),
          backgroundColor: Theme.of(context).colorScheme.error));
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showPaymentSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              icon: CustomIconWidget(
                  iconName: 'check_circle',
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 48),
              title: const Text('تم إنشاء الفاتورة بنجاح!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('رقم الفاتورة: ${_invoiceNumberController.text}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center),
                SizedBox(height: 2.h),
                Text(
                    'المبلغ الإجمالي: \$${NumberFormat('#,##0.00').format(_calculateTotalAmount())}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
              ]),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(context,
                          AppPages.purchaseOrderSelection, (route) => false);
                    },
                    child: const Text('العودة للرئيسية')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                          context, AppPages.invoiceDetail,
                          arguments: {
                            'invoiceNumber': _invoiceNumberController.text,
                            'supplier': _purchaseOrder?['supplier'] ?? '',
                            'totalAmount': _calculateTotalAmount(),
                            'products': _products
                                .where(
                                    (p) => (p['receivedQuantity'] as int) > 0)
                                .toList(),
                          });
                    },
                    child: const Text('عرض الفاتورة')),
              ]);
        });
  }

  void _cancelInvoiceCreation() {
    if (_hasUnsavedChanges) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text('إلغاء إنشاء الفاتورة؟'),
                content: const Text(
                    'لديك تغييرات غير محفوظة. هل أنت متأكد من الإلغاء؟'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('متابعة التحرير')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('إلغاء',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error))),
                ]);
          });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
            title: const Text('إنشاء فاتورة شراء'),
            leading: IconButton(
                onPressed: _cancelInvoiceCreation,
                icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 24)),
            actions: [
              if (_hasUnsavedChanges)
                Container(
                    margin: EdgeInsets.only(right: 2.w),
                    child: TextButton(
                        onPressed: _autoSave,
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          CustomIconWidget(
                              iconName: 'save',
                              color: theme.colorScheme.tertiary,
                              size: 16),
                          SizedBox(width: 1.w),
                          Text('حُفظ تلقائياً',
                              style: TextStyle(
                                  color: theme.colorScheme.tertiary,
                                  fontSize: 10.sp)),
                        ]))),
            ]),
        body: Form(
            key: _formKey,
            child: Column(children: [
              // Fixed Header Section
              Container(
                  color: theme.colorScheme.surface,
                  padding: EdgeInsets.all(4.w),
                  child: Column(children: [
                    // Search Bar
                    ProductSearchBarWidget(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        onBarcodeScanned: _onBarcodeScanned),

                    SizedBox(height: 2.h),

                    // Invoice Number
                    TextFormField(
                        controller: _invoiceNumberController,
                        decoration: InputDecoration(
                            labelText: 'رقم الفاتورة *',
                            prefixIcon: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                    iconName: 'receipt_long',
                                    color: theme.colorScheme.primary,
                                    size: 20))),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'رقم الفاتورة مطلوب';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _hasUnsavedChanges = true;
                          });
                        }),
                  ])),

              // Products Table (Scrollable)
              Expanded(
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_purchaseOrder != null) ...[
                              // Purchase Order Info
                              Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.2))),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('بيانات طلب الشراء',
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: theme
                                                        .colorScheme.primary)),
                                        SizedBox(height: 1.h),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(_purchaseOrder!['poNumber'],
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700)),
                                              Text(_purchaseOrder!['supplier'],
                                                  style: theme
                                                      .textTheme.bodyMedium),
                                            ]),
                                      ])),

                              SizedBox(height: 3.h),
                            ],

                            // Products Table
                            Text('المنتجات من طلب الشراء',
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            SizedBox(height: 2.h),

                            InvoiceProductsTableWidget(
                                products: _products,
                                searchQuery: _searchQuery,
                                onProductDataChanged: _onProductDataChanged),

                            SizedBox(
                                height: 10.h), // Space for fixed bottom section
                          ]))),

              // Fixed Bottom Section (Running Total + Action Button)
              Container(
                  decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                            color: theme.shadowColor.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, -2)),
                      ]),
                  child: Column(children: [
                    // Running Total
                    RunningTotalWidget(
                        products: _products,
                        totalAmount: _calculateTotalAmount()),

                    // Continue to Payment Button
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        child: ElevatedButton(
                            onPressed: _isSaving ? null : _proceedToPayment,
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: _isSaving
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                theme.colorScheme.onPrimary)))
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        CustomIconWidget(
                                            iconName: 'payment',
                                            color: theme.colorScheme.onPrimary,
                                            size: 20),
                                        SizedBox(width: 2.w),
                                        Text('متابعة الدفع',
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600)),
                                      ]))),
                  ])),
            ])));
  }
}
