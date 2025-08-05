import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductRowWidget extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> availableProducts;
  final Function(Map<String, dynamic>) onProductChanged;
  final VoidCallback onDelete;
  final bool isRTL;

  const ProductRowWidget({
    super.key,
    required this.product,
    required this.availableProducts,
    required this.onProductChanged,
    required this.onDelete,
    this.isRTL = false,
  });

  @override
  State<ProductRowWidget> createState() => _ProductRowWidgetState();
}

class _ProductRowWidgetState extends State<ProductRowWidget> {
  late TextEditingController _quantityController;
  String? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
        text: widget.product['quantity']?.toString() ?? '1');
    _selectedProductId = widget.product['productId']?.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(String value) {
    final quantity = int.tryParse(value) ?? 1;
    final updatedProduct = Map<String, dynamic>.from(widget.product);
    updatedProduct['quantity'] = quantity;
    updatedProduct['totalPrice'] =
        (updatedProduct['price'] as double) * quantity;
    widget.onProductChanged(updatedProduct);
  }

  void _updateProduct(String? productId) {
    if (productId == null) return;

    final selectedProduct = widget.availableProducts.firstWhere(
      (p) => p['id'].toString() == productId,
      orElse: () => widget.availableProducts.first,
    );

    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final updatedProduct = {
      'id': widget.product['id'],
      'productId': selectedProduct['id'],
      'name': selectedProduct['name'],
      'price': selectedProduct['price'],
      'quantity': quantity,
      'totalPrice': (selectedProduct['price'] as double) * quantity,
      'barcode': selectedProduct['barcode'],
    };

    setState(() {
      _selectedProductId = productId;
    });

    widget.onProductChanged(updatedProduct);
  }

  void _incrementQuantity() {
    final currentQuantity = int.tryParse(_quantityController.text) ?? 1;
    final newQuantity = currentQuantity + 1;
    _quantityController.text = newQuantity.toString();
    _updateQuantity(newQuantity.toString());
  }

  void _decrementQuantity() {
    final currentQuantity = int.tryParse(_quantityController.text) ?? 1;
    if (currentQuantity > 1) {
      final newQuantity = currentQuantity - 1;
      _quantityController.text = newQuantity.toString();
      _updateQuantity(newQuantity.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalPrice = widget.product['totalPrice'] ?? 0.0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Selection Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isRTL ? 'المنتج' : 'Product',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedProductId,
                            isExpanded: true,
                            hint: Text(
                              widget.isRTL ? 'اختر المنتج' : 'Select Product',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            items: widget.availableProducts.map((product) {
                              return DropdownMenuItem<String>(
                                value: product['id'].toString(),
                                child: Text(
                                  product['name'] as String,
                                  style: theme.textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: _updateProduct,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                // Delete Button
                InkWell(
                  onTap: widget.onDelete,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'delete_outline',
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Quantity and Price Row
            Row(
              children: [
                // Quantity Section
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isRTL ? 'الكمية' : 'Quantity',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          // Decrement Button
                          InkWell(
                            onTap: _decrementQuantity,
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: 'remove',
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                            ),
                          ),

                          // Quantity Input
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2.w),
                              child: TextFormField(
                                controller: _quantityController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 1.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: _updateQuantity,
                              ),
                            ),
                          ),

                          // Increment Button
                          InkWell(
                            onTap: _incrementQuantity,
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: EdgeInsets.all(1.5.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: CustomIconWidget(
                                iconName: 'add',
                                color: theme.colorScheme.primary,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 4.w),

                // Price Section
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.isRTL ? 'السعر الإجمالي' : 'Total Price',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.5.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Product Details
            if (widget.product['name'] != null) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product['name'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${widget.isRTL ? 'سعر الوحدة:' : 'Unit Price:'} \$${(widget.product['price'] ?? 0.0).toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.product['barcode'] != null) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.product['barcode'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
