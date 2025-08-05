import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

import './widgets/barcode_scanner_widget.dart';
import './widgets/currency_selector_widget.dart';
import './widgets/order_header_widget.dart';
import './widgets/order_total_widget.dart';
import './widgets/product_row_widget.dart';

class CreatePurchaseOrder extends StatefulWidget {
  const CreatePurchaseOrder({super.key});

  @override
  State<CreatePurchaseOrder> createState() => _CreatePurchaseOrderState();
}

class _CreatePurchaseOrderState extends State<CreatePurchaseOrder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _orderNameController = TextEditingController();

  String? _selectedSupplier;
  Currency _selectedCurrency = Currency.syp;
  List<Map<String, dynamic>> _orderProducts = [];
  bool _isLoading = false;
  bool _showBarcodeScanner = false;
  int? _scanningProductIndex;

  // Mock data
  final List<Map<String, dynamic>> _suppliers = [
    {
      "id": 1,
      "name": "Damascus Medical Supplies",
      "contact": "+963 11 123 4567",
      "email": "info@damascusmedical.sy",
      "address": "Damascus, Syria"
    },
    {
      "id": 2,
      "name": "Aleppo Pharmaceutical Co.",
      "contact": "+963 21 987 6543",
      "email": "orders@aleppopharma.sy",
      "address": "Aleppo, Syria"
    },
    {
      "id": 3,
      "name": "Homs Healthcare Solutions",
      "contact": "+963 31 555 0123",
      "email": "sales@homshealthcare.sy",
      "address": "Homs, Syria"
    },
    {
      "id": 4,
      "name": "Lattakia Medical Equipment",
      "contact": "+963 41 777 8899",
      "email": "support@lattakiamedical.sy",
      "address": "Lattakia, Syria"
    },
  ];

  final List<Map<String, dynamic>> _availableProducts = [
    {
      "id": 1,
      "name": "Paracetamol 500mg Tablets",
      "barcode": "1234567890123",
      "price": 25.50,
      "category": "Pain Relief",
      "description": "Effective pain and fever relief medication"
    },
    {
      "id": 2,
      "name": "Amoxicillin 250mg Capsules",
      "barcode": "9876543210987",
      "price": 45.75,
      "category": "Antibiotics",
      "description": "Broad-spectrum antibiotic for bacterial infections"
    },
    {
      "id": 3,
      "name": "Insulin Syringes 1ml",
      "barcode": "5555666677778",
      "price": 12.25,
      "category": "Diabetes Care",
      "description": "Sterile disposable syringes for insulin injection"
    },
    {
      "id": 4,
      "name": "Blood Pressure Monitor",
      "barcode": "1111222233334",
      "price": 89.99,
      "category": "Medical Devices",
      "description": "Digital automatic blood pressure monitor"
    },
    {
      "id": 5,
      "name": "Surgical Gloves (Box of 100)",
      "barcode": "4444555566667",
      "price": 18.50,
      "category": "Medical Supplies",
      "description": "Latex-free disposable surgical gloves"
    },
    {
      "id": 6,
      "name": "Thermometer Digital",
      "barcode": "7777888899990",
      "price": 15.75,
      "category": "Medical Devices",
      "description": "Fast and accurate digital thermometer"
    },
  ];

  @override
  void initState() {
    super.initState();
    _addNewProduct();
  }

  @override
  void dispose() {
    _orderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _showBarcodeScanner ? _buildMainContent() : _buildMainContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Create Purchase Order',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      elevation: Theme.of(context).appBarTheme.elevation,
      leading: IconButton(
        onPressed: () => _handleBackNavigation(),
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: Theme.of(context).appBarTheme.foregroundColor!,
          size: 20,
        ),
      ),
      actions: [
        if (!_showBarcodeScanner)
          TextButton.icon(
            onPressed: _isLoading ? null : _saveOrder,
            icon: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'save',
                    color: Theme.of(context).appBarTheme.foregroundColor!,
                    size: 18,
                  ),
            label: Text(
              _isLoading ? 'Saving...' : 'Save',
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderHeaderWidget(
                    orderNameController: _orderNameController,
                    selectedSupplier: _selectedSupplier,
                    suppliers: _suppliers,
                    onSupplierChanged: (value) {
                      setState(() {
                        _selectedSupplier = value;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  CurrencySelectorWidget(
                    selectedCurrency: _selectedCurrency,
                    onCurrencyChanged: (currency) {
                      setState(() {
                        _selectedCurrency = currency;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  _buildProductsSection(),
                  SizedBox(height: 2.h),
                  _buildAddProductButton(),
                  SizedBox(height: 10.h), // Space for bottom total widget
                ],
              ),
            ),
          ),
        ),
        OrderTotalWidget(
          products: _orderProducts,
          currencySymbol: _getCurrencySymbol(),
          onSave: _saveOrder,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_orderProducts.length} items',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            if (_orderProducts.isEmpty)
              _buildEmptyProductsState()
            else
              ..._orderProducts.asMap().entries.map((entry) {
                final index = entry.key;
                final product = entry.value;
                return ProductRowWidget(
                  key: ValueKey('product_$index'),
                  product: product,
                  availableProducts: _availableProducts,
                  onProductChanged: (updatedProduct) {
                    setState(() {
                      _orderProducts[index] = updatedProduct;
                    });
                  },
                  onDelete: () => _removeProduct(index),
                  onBarcodeScan: () => _startBarcodeScanning(index),
                  currencySymbol: _getCurrencySymbol(),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProductsState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'inventory_2_outlined',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No products added yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Add products to create your purchase order',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAddProductButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: OutlinedButton.icon(
        onPressed: _addNewProduct,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        label: Text(
          'Add Product',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Widget _buildBarcodeScanner() {
  //   // return BarcodeScannerWidget(
  //   //   onBarcodeScanned: (barcode) {
  //   //     _handleBarcodeScanned(barcode);
  //   //   },
  //   //   onClose: () {
  //   //     setState(() {
  //   //       _showBarcodeScanner = false;
  //   //       _scanningProductIndex = null;
  //   //     });
  //   //   },
  //   // );
  // }

  void _addNewProduct() {
    setState(() {
      _orderProducts.add({
        'productId': null,
        'productName': null,
        'quantity': 1,
        'unitPrice': 0.0,
        'total': 0.0,
      });
    });
  }

  void _removeProduct(int index) {
    if (_orderProducts.length > 1) {
      setState(() {
        _orderProducts.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('At least one product is required'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _startBarcodeScanning(int productIndex) {
    setState(() {
      _showBarcodeScanner = true;
      _scanningProductIndex = productIndex;
    });
  }

  void _handleBarcodeScanned(String barcode) {
    setState(() {
      _showBarcodeScanner = false;
    });

    // Find product by barcode
    final product = _availableProducts.firstWhere(
      (p) => p['barcode'] == barcode,
      orElse: () => {},
    );

    if (product.isNotEmpty && _scanningProductIndex != null) {
      // Update the product at the scanning index
      final updatedProduct =
          Map<String, dynamic>.from(_orderProducts[_scanningProductIndex!]);
      updatedProduct['productId'] = product['id'];
      updatedProduct['productName'] = product['name'];
      updatedProduct['unitPrice'] = product['price'];
      updatedProduct['total'] =
          (product['price'] as double) * (updatedProduct['quantity'] as int);

      setState(() {
        _orderProducts[_scanningProductIndex!] = updatedProduct;
        _scanningProductIndex = null;
      });

      // Provide haptic feedback
      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product "${product['name']}" added successfully'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
        ),
      );
    } else {
      setState(() {
        _scanningProductIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product with barcode "$barcode" not found'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _getCurrencySymbol() {
    return _selectedCurrency == Currency.syp ? 'ليرة ' : '\$ ';
  }

  void _handleBackNavigation() {
    if (_hasUnsavedChanges()) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.pop(context);
    }
  }

  bool _hasUnsavedChanges() {
    return _orderNameController.text.trim().isNotEmpty ||
        _selectedSupplier != null ||
        _orderProducts.any((product) => product['productId'] != null);
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate products
    if (_orderProducts.isEmpty ||
        !_orderProducts.any((p) => p['productId'] != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least one product'),
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

      // Create order data
      final orderData = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': _orderNameController.text.trim(),
        'supplierId': _selectedSupplier,
        'supplierName': _suppliers.firstWhere(
          (s) => s['id'].toString() == _selectedSupplier,
          orElse: () => {'name': 'Unknown'},
        )['name'],
        'currency': _selectedCurrency == Currency.syp ? 'SYP' : 'USD',
        'products':
            _orderProducts.where((p) => p['productId'] != null).toList(),
        'totalAmount': _orderProducts.fold<double>(
          0.0,
          (sum, product) => sum + ((product['total'] as double?) ?? 0.0),
        ),
        'status': 'Draft',
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Provide haptic feedback
      HapticFeedback.mediumImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Purchase order "${orderData['name']}" created successfully'),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/purchase-order-detail',
                arguments: orderData,
              );
            },
          ),
        ),
      );

      // Navigate back to order list
      Navigator.pushReplacementNamed(context, '/purchase-order-list');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create order: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
