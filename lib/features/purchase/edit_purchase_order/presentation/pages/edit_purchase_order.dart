import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

import './widgets/barcode_scanner_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/product_row_widget.dart';

class EditPurchaseOrder extends StatefulWidget {
  const EditPurchaseOrder({super.key});

  @override
  State<EditPurchaseOrder> createState() => _EditPurchaseOrderState();
}

class _EditPurchaseOrderState extends State<EditPurchaseOrder> {
  final _formKey = GlobalKey<FormState>();
  final _orderNameController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isLoading = false;
  bool _hasUnsavedChanges = false;
  bool _isRTL = false;
  String _selectedCurrency = 'USD';
  String? _selectedSupplierId;
  List<Map<String, dynamic>> _products = [];
  int _nextProductId = 1;

  // Mock data
  final List<Map<String, dynamic>> _availableProducts = [
    {
      'id': 1,
      'name': 'Paracetamol 500mg',
      'price': 12.50,
      'barcode': '1234567890123',
      'category': 'Pain Relief',
    },
    {
      'id': 2,
      'name': 'Amoxicillin 250mg',
      'price': 25.00,
      'barcode': '2345678901234',
      'category': 'Antibiotics',
    },
    {
      'id': 3,
      'name': 'Ibuprofen 400mg',
      'price': 18.75,
      'barcode': '3456789012345',
      'category': 'Anti-inflammatory',
    },
    {
      'id': 4,
      'name': 'Vitamin D3 1000IU',
      'price': 32.00,
      'barcode': '4567890123456',
      'category': 'Vitamins',
    },
    {
      'id': 5,
      'name': 'Omeprazole 20mg',
      'price': 28.50,
      'barcode': '5678901234567',
      'category': 'Gastric',
    },
  ];

  final List<Map<String, dynamic>> _suppliers = [
    {
      'id': '1',
      'name': 'Damascus Pharmaceuticals',
      'nameAr': 'شركة دمشق للأدوية',
      'contact': '+963 11 123 4567',
      'email': 'info@damascuspharm.sy',
    },
    {
      'id': '2',
      'name': 'Aleppo Medical Supplies',
      'nameAr': 'مستلزمات حلب الطبية',
      'contact': '+963 21 987 6543',
      'email': 'sales@aleppomedical.sy',
    },
    {
      'id': '3',
      'name': 'Syrian Health Distribution',
      'nameAr': 'التوزيع الصحي السوري',
      'contact': '+963 11 555 0123',
      'email': 'orders@syrianhealthdist.com',
    },
  ];

  // Mock existing order data
  final Map<String, dynamic> _existingOrder = {
    'id': 'PO-2025-001',
    'name': 'Emergency Medical Supplies Order',
    'nameAr': 'طلب المستلزمات الطبية الطارئة',
    'supplierId': '1',
    'currency': 'USD',
    'status': 'Draft',
    'createdDate': '2025-01-15',
    'products': [
      {
        'id': 1,
        'productId': 1,
        'name': 'Paracetamol 500mg',
        'price': 12.50,
        'quantity': 100,
        'totalPrice': 1250.0,
        'barcode': '1234567890123',
      },
      {
        'id': 2,
        'productId': 3,
        'name': 'Ibuprofen 400mg',
        'price': 18.75,
        'quantity': 50,
        'totalPrice': 937.5,
        'barcode': '3456789012345',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadExistingOrderData();
  }

  @override
  void dispose() {
    _orderNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadExistingOrderData() {
    setState(() {
      _orderNameController.text = _existingOrder['name'] as String;
      _selectedSupplierId = _existingOrder['supplierId'] as String;
      _selectedCurrency = _existingOrder['currency'] as String;
      _products =
          List<Map<String, dynamic>>.from(_existingOrder['products'] as List);
      _nextProductId = _products.length + 1;
    });
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _addProduct() {
    setState(() {
      _products.add({
        'id': _nextProductId++,
        'productId': null,
        'name': null,
        'price': 0.0,
        'quantity': 1,
        'totalPrice': 0.0,
        'barcode': null,
      });
    });
    _markAsChanged();

    // Scroll to bottom to show new product
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeProduct(int productId) {
    setState(() {
      _products.removeWhere((product) => product['id'] == productId);
    });
    _markAsChanged();
  }

  void _updateProduct(Map<String, dynamic> updatedProduct) {
    setState(() {
      final index =
          _products.indexWhere((p) => p['id'] == updatedProduct['id']);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
    });
    _markAsChanged();
  }

  void _onBarcodeScanned(String barcode) {
    final product = _availableProducts.firstWhere(
      (p) => p['barcode'] == barcode,
      orElse: () => _availableProducts.first,
    );

    // Add product with scanned barcode
    setState(() {
      _products.add({
        'id': _nextProductId++,
        'productId': product['id'],
        'name': product['name'],
        'price': product['price'],
        'quantity': 1,
        'totalPrice': product['price'],
        'barcode': product['barcode'],
      });
    });
    _markAsChanged();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRTL
              ? 'تم إضافة المنتج: ${product['name']}'
              : 'Product added: ${product['name']}',
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  Future<void> _updateOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRTL
                ? 'يرجى إضافة منتج واحد على الأقل'
                : 'Please add at least one product',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_selectedSupplierId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRTL ? 'يرجى اختيار المورد' : 'Please select a supplier',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isRTL
                  ? 'تم تحديث الطلب بنجاح'
                  : 'Purchase order updated successfully',
            ),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );

        setState(() {
          _hasUnsavedChanges = false;
        });

        // Navigate back to order list
        Navigator.pushReplacementNamed(context, '/purchase-order-list');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isRTL ? 'خطأ في تحديث الطلب' : 'Failed to update order',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _isRTL ? 'تغييرات غير محفوظة' : 'Unsaved Changes',
        ),
        content: Text(
          _isRTL
              ? 'لديك تغييرات غير محفوظة. هل تريد المغادرة بدون حفظ؟'
              : 'You have unsaved changes. Do you want to leave without saving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              _isRTL ? 'البقاء' : 'Stay',
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              _isRTL ? 'المغادرة' : 'Leave',
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            _isRTL ? 'تعديل طلب الشراء' : 'Edit Purchase Order',
            style: theme.appBarTheme.titleTextStyle,
          ),
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: theme.appBarTheme.foregroundColor!,
              size: 24,
            ),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            if (_hasUnsavedChanges)
              Container(
                margin: EdgeInsets.only(right: 2.w),
                child: CustomIconWidget(
                  iconName: 'circle',
                  color: Colors.orange,
                  size: 8,
                ),
              ),
            TextButton(
              onPressed: _isLoading ? null : _updateOrder,
              child: Text(
                _isRTL ? 'تحديث' : 'Update',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: _isLoading
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                      : theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        bottom: 20.h, // Space for summary
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order Basic Info
                          _buildOrderInfoSection(theme),

                          SizedBox(height: 2.h),

                          // Products Section
                          _buildProductsSection(theme),

                          SizedBox(height: 2.h),

                          // Add Product Button
                          _buildAddProductButton(theme),

                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sticky Order Summary
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: OrderSummaryWidget(
                products: _products,
                currency: _selectedCurrency,
                isRTL: _isRTL,
              ),
            ),

            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        SizedBox(height: 2.h),
                        Text(
                          _isRTL ? 'جاري تحديث الطلب...' : 'Updating order...',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoSection(ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'edit_note',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                _isRTL ? 'معلومات الطلب' : 'Order Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Order Name
          TextFormField(
            controller: _orderNameController,
            decoration: InputDecoration(
              labelText: _isRTL ? 'اسم الطلب' : 'Order Name',
              hintText: _isRTL ? 'أدخل اسم الطلب' : 'Enter order name',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'receipt_long',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return _isRTL ? 'اسم الطلب مطلوب' : 'Order name is required';
              }
              return null;
            },
            onChanged: (_) => _markAsChanged(),
          ),

          SizedBox(height: 3.h),

          // Supplier Selection
          DropdownButtonFormField<String>(
            value: _selectedSupplierId,
            decoration: InputDecoration(
              labelText: _isRTL ? 'المورد' : 'Supplier',
              hintText: _isRTL ? 'اختر المورد' : 'Select supplier',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'business',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            items: _suppliers.map((supplier) {
              return DropdownMenuItem<String>(
                value: supplier['id'] as String,
                child: Text(
                  _isRTL
                      ? supplier['nameAr'] as String
                      : supplier['name'] as String,
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSupplierId = value;
              });
              _markAsChanged();
            },
            validator: (value) {
              if (value == null) {
                return _isRTL ? 'المورد مطلوب' : 'Supplier is required';
              }
              return null;
            },
          ),

          SizedBox(height: 3.h),

          // Currency Selection
          DropdownButtonFormField<String>(
            value: _selectedCurrency,
            decoration: InputDecoration(
              labelText: _isRTL ? 'العملة' : 'Currency',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'attach_money',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            items: [
              DropdownMenuItem<String>(
                value: 'USD',
                child: Text(
                  _isRTL ? 'دولار أمريكي (USD)' : 'US Dollar (USD)',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              DropdownMenuItem<String>(
                value: 'SYP',
                child: Text(
                  _isRTL ? 'ليرة سورية (SYP)' : 'Syrian Pound (SYP)',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCurrency = value!;
              });
              _markAsChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'inventory_2',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                _isRTL ? 'المنتجات' : 'Products',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_products.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Products List
        if (_products.isEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: 'inventory_2_outlined',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 48,
                ),
                SizedBox(height: 2.h),
                Text(
                  _isRTL ? 'لا توجد منتجات' : 'No products added',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  _isRTL
                      ? 'اضغط على "إضافة منتج" لبدء إضافة المنتجات'
                      : 'Tap "Add Product" to start adding products',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return ProductRowWidget(
                key: ValueKey(product['id']),
                product: product,
                availableProducts: _availableProducts,
                onProductChanged: _updateProduct,
                onDelete: () => _removeProduct(product['id'] as int),
                isRTL: _isRTL,
              );
            },
          ),
      ],
    );
  }

  Widget _buildAddProductButton(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          // Add Product Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _addProduct,
              icon: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                _isRTL ? 'إضافة منتج' : 'Add Product',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Barcode Scanner Button
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => BarcodeScannerWidget(
              //       onBarcodeScanned: _onBarcodeScanned,
              //       isRTL: _isRTL,
              //     ),
              //   ),
              // );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              padding: EdgeInsets.all(2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: theme.colorScheme.onSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
