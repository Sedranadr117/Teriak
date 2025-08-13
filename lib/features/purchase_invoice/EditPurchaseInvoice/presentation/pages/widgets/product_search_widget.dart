import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductSearchWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductSelected;
  final List<Map<String, dynamic>> existingProducts;

  const ProductSearchWidget({
    super.key,
    required this.onProductSelected,
    required this.existingProducts,
  });

  @override
  State<ProductSearchWidget> createState() => _ProductSearchWidgetState();
}

class _ProductSearchWidgetState extends State<ProductSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 'P001',
      'name': 'Paracetamol 500mg',
      'barcode': '1234567890123',
      'unitPrice': 2.50,
      'category': 'Pain Relief',
      'manufacturer': 'Pharma Co.',
    },
    {
      'id': 'P002',
      'name': 'Amoxicillin 250mg',
      'barcode': '2345678901234',
      'unitPrice': 15.75,
      'category': 'Antibiotics',
      'manufacturer': 'Medical Labs',
    },
    {
      'id': 'P003',
      'name': 'Vitamin D3 1000 IU',
      'barcode': '3456789012345',
      'unitPrice': 8.25,
      'category': 'Vitamins',
      'manufacturer': 'Health Plus',
    },
    {
      'id': 'P004',
      'name': 'Insulin Glargine 100 units/ml',
      'barcode': '4567890123456',
      'unitPrice': 45.00,
      'category': 'Diabetes',
      'manufacturer': 'Diabetes Care',
    },
    {
      'id': 'P005',
      'name': 'Omeprazole 20mg',
      'barcode': '5678901234567',
      'unitPrice': 12.30,
      'category': 'Gastric',
      'manufacturer': 'Gastro Med',
    },
    {
      'id': 'P006',
      'name': 'Metformin 500mg',
      'barcode': '6789012345678',
      'unitPrice': 6.80,
      'category': 'Diabetes',
      'manufacturer': 'Diabetes Care',
    },
    {
      'id': 'P007',
      'name': 'Aspirin 75mg',
      'barcode': '7890123456789',
      'unitPrice': 3.20,
      'category': 'Cardiovascular',
      'manufacturer': 'Heart Health',
    },
    {
      'id': 'P008',
      'name': 'Cetirizine 10mg',
      'barcode': '8901234567890',
      'unitPrice': 4.50,
      'category': 'Antihistamine',
      'manufacturer': 'Allergy Relief',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'add_circle_outline',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Add New Product',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Search Field with Barcode Scanner
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'Search products or scan barcode',
                      hintText: 'Enter product name or barcode',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _performSearch,
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _openBarcodeScanner,
                    icon: CustomIconWidget(
                      iconName: 'qr_code_scanner',
                      color: theme.colorScheme.onPrimary,
                      size: 24,
                    ),
                    tooltip: 'Scan Barcode',
                  ),
                ),
              ],
            ),

            // Search Results
            if (_isSearching) ...[
              SizedBox(height: 2.h),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ] else if (_searchResults.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Container(
                constraints: BoxConstraints(maxHeight: 30.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  itemBuilder: (context, index) {
                    final product = _searchResults[index];
                    final isAlreadyAdded = widget.existingProducts
                        .any((p) => p['id'] == product['id']);

                    return ListTile(
                      leading: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'medication',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        product['name'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Code: ${product['id']} | \$${(product['unitPrice'] as double).toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            product['category'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      trailing: isAlreadyAdded
                          ? CustomIconWidget(
                              iconName: 'check_circle',
                              color: theme.colorScheme.onSecondary,
                              size: 24,
                            )
                          : CustomIconWidget(
                              iconName: 'add_circle',
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                      onTap:
                          isAlreadyAdded ? null : () => _selectProduct(product),
                      enabled: !isAlreadyAdded,
                    );
                  },
                ),
              ),
            ] else if (_searchController.text.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'search_off',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'No products found for "${_searchController.text}"',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final results = _allProducts.where((product) {
          final name = (product['name'] as String).toLowerCase();
          final barcode = product['barcode'] as String;
          final category = (product['category'] as String).toLowerCase();
          final searchQuery = query.toLowerCase();

          return name.contains(searchQuery) ||
              barcode.contains(searchQuery) ||
              category.contains(searchQuery);
        }).toList();

        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  void _selectProduct(Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    widget.onProductSelected(product);
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _searchResults = [];
    });
  }

  void _openBarcodeScanner() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scan Product Barcode',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Camera Scanner\n(Implementation Ready)',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Position the barcode within the frame to scan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
