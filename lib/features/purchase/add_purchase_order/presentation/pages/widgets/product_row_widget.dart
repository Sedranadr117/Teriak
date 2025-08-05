import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductRowWidget extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> availableProducts;
  final Function(Map<String, dynamic>) onProductChanged;
  final Function() onDelete;
  final Function() onBarcodeScan;
  final String currencySymbol;

  const ProductRowWidget({
    super.key,
    required this.product,
    required this.availableProducts,
    required this.onProductChanged,
    required this.onDelete,
    required this.onBarcodeScan,
    required this.currencySymbol,
  });

  @override
  State<ProductRowWidget> createState() => _ProductRowWidgetState();
}

class _ProductRowWidgetState extends State<ProductRowWidget> {
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.product['quantity']?.toString() ?? '1',
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 2.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(),
            SizedBox(height: 2.h),
            _buildProductDropdown(),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(flex: 2, child: _buildQuantityInput()),
                SizedBox(width: 3.w),
                Expanded(flex: 2, child: _buildPriceDisplay()),
                SizedBox(width: 3.w),
                Expanded(flex: 2, child: _buildTotalDisplay()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Product ${widget.availableProducts.indexOf(widget.product) + 1}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        IconButton(
          onPressed: widget.onDelete,
          icon: CustomIconWidget(
            iconName: 'delete_outline',
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          constraints: BoxConstraints(
            minWidth: 8.w,
            minHeight: 8.w,
          ),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildProductDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product *',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: widget.product['productId']?.toString(),
                decoration: InputDecoration(
                  hintText: 'Select product',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.5.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                items: widget.availableProducts
                    .map<DropdownMenuItem<String>>((product) {
                  return DropdownMenuItem<String>(
                    value: product['id'].toString(),
                    child: Text(
                      product['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final selectedProduct = widget.availableProducts.firstWhere(
                      (p) => p['id'].toString() == value,
                    );
                    final updatedProduct =
                        Map<String, dynamic>.from(widget.product);
                    updatedProduct['productId'] = selectedProduct['id'];
                    updatedProduct['productName'] = selectedProduct['name'];
                    updatedProduct['unitPrice'] = selectedProduct['price'];
                    updatedProduct['total'] =
                        (selectedProduct['price'] as double) *
                            (updatedProduct['quantity'] as int);
                    widget.onProductChanged(updatedProduct);
                  }
                },
                isExpanded: true,
                icon: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: widget.onBarcodeScan,
                icon: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                constraints: BoxConstraints(
                  minWidth: 12.w,
                  minHeight: 6.h,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () => _updateQuantity(-1),
                icon: CustomIconWidget(
                  iconName: 'remove',
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                constraints: BoxConstraints(
                  minWidth: 8.w,
                  minHeight: 4.h,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _quantityController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 1.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  final quantity = int.tryParse(value) ?? 1;
                  _updateProductQuantity(quantity);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: () => _updateQuantity(1),
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                constraints: BoxConstraints(
                  minWidth: 8.w,
                  minHeight: 4.h,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit Price',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 1.5.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${widget.currencySymbol}${(widget.product['unitPrice'] ?? 0.0).toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 1.5.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${widget.currencySymbol}${(widget.product['total'] ?? 0.0).toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _updateQuantity(int delta) {
    final currentQuantity = int.tryParse(_quantityController.text) ?? 1;
    final newQuantity = (currentQuantity + delta).clamp(1, 9999);
    _quantityController.text = newQuantity.toString();
    _updateProductQuantity(newQuantity);
  }

  void _updateProductQuantity(int quantity) {
    final updatedProduct = Map<String, dynamic>.from(widget.product);
    updatedProduct['quantity'] = quantity;
    updatedProduct['total'] = (updatedProduct['unitPrice'] ?? 0.0) * quantity;
    widget.onProductChanged(updatedProduct);
  }
}
