import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(int, Map<String, dynamic>) onProductUpdated;
  final Function(int) onProductRemoved;

  const ProductTableWidget({
    super.key,
    required this.products,
    required this.onProductUpdated,
    required this.onProductRemoved,
  });

  @override
  State<ProductTableWidget> createState() => _ProductTableWidgetState();
}

class _ProductTableWidgetState extends State<ProductTableWidget> {
  final Map<int, bool> _expandedRows = {};
  final Map<int, Map<String, TextEditingController>> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.products.length; i++) {
      final product = widget.products[i];
      _controllers[i] = {
        'receivedQuantity': TextEditingController(
          text: (product['receivedQuantity'] as int? ?? 0).toString(),
        ),
        'bonusQuantity': TextEditingController(
          text: (product['bonusQuantity'] as int? ?? 0).toString(),
        ),
        'batchNumber': TextEditingController(
          text: product['batchNumber'] as String? ?? '',
        ),
        'actualPrice': TextEditingController(
          text: (product['actualPrice'] as double? ?? 0.0).toStringAsFixed(2),
        ),
      };
    }
  }

  void _disposeControllers() {
    for (final controllerMap in _controllers.values) {
      for (final controller in controllerMap.values) {
        controller.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.products.isEmpty) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: 'inventory_2',
                color: theme.colorScheme.onSurfaceVariant,
                size: 48,
              ),
              SizedBox(height: 2.h),
              Text(
                'No Products Added',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Use the search above to add products to this invoice',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'inventory',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Products (${widget.products.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Modified',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.products.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            itemBuilder: (context, index) => _buildProductRow(context, index),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, int index) {
    final theme = Theme.of(context);
    final product = widget.products[index];
    final isExpanded = _expandedRows[index] ?? false;
    final controllers = _controllers[index]!;

    return Column(
      children: [
        // Main Product Row
        InkWell(
          onTap: () {
            setState(() {
              _expandedRows[index] = !isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Product Header
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Code: ${product['id']} | \$${(product['unitPrice'] as double).toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),

                    // Quantity Controls
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controllers['receivedQuantity'],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                labelText: 'Received',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                              onChanged: (value) => _updateProduct(index,
                                  'receivedQuantity', int.tryParse(value) ?? 0),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            width: 12.w,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => _incrementBonus(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'add',
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  (product['bonusQuantity'] as int? ?? 0)
                                      .toString(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                GestureDetector(
                                  onTap: () => _decrementBonus(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'remove',
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 2.w),

                    // Actions
                    Column(
                      children: [
                        CustomIconWidget(
                          iconName: isExpanded ? 'expand_less' : 'expand_more',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: () => _showDeleteConfirmation(context, index),
                          child: CustomIconWidget(
                            iconName: 'delete_outline',
                            color: theme.colorScheme.error,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Quick Summary
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bonus: ${product['bonusQuantity'] ?? 0}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.surfaceBright,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Total: \$${_calculateProductTotal(product).toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Expanded Details
        if (isExpanded) ...[
          Container(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controllers['batchNumber'],
                        decoration: const InputDecoration(
                          labelText: 'Batch Number',
                          prefixIcon: Icon(Icons.qr_code),
                        ),
                        onChanged: (value) =>
                            _updateProduct(index, 'batchNumber', value),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectExpirationDate(context, index),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Expiration Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            _formatDate(product['expirationDate']
                                    as DateTime? ??
                                DateTime.now().add(const Duration(days: 365))),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controllers['actualPrice'],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Actual Price',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        onChanged: (value) => _updateProduct(index,
                            'actualPrice', double.tryParse(value) ?? 0.0),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Line Total',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              '\$${_calculateProductTotal(product).toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _updateProduct(int index, String field, dynamic value) {
    final updatedProduct = Map<String, dynamic>.from(widget.products[index]);
    updatedProduct[field] = value;
    widget.onProductUpdated(index, updatedProduct);
  }

  void _incrementBonus(int index) {
    HapticFeedback.lightImpact();
    final currentBonus = widget.products[index]['bonusQuantity'] as int? ?? 0;
    _updateProduct(index, 'bonusQuantity', currentBonus + 1);
    _controllers[index]!['bonusQuantity']!.text = (currentBonus + 1).toString();
  }

  void _decrementBonus(int index) {
    HapticFeedback.lightImpact();
    final currentBonus = widget.products[index]['bonusQuantity'] as int? ?? 0;
    if (currentBonus > 0) {
      _updateProduct(index, 'bonusQuantity', currentBonus - 1);
      _controllers[index]!['bonusQuantity']!.text =
          (currentBonus - 1).toString();
    }
  }

  double _calculateProductTotal(Map<String, dynamic> product) {
    final receivedQty = product['receivedQuantity'] as int? ?? 0;
    final bonusQty = product['bonusQuantity'] as int? ?? 0;
    final actualPrice = product['actualPrice'] as double? ??
        (product['unitPrice'] as double? ?? 0.0);

    return (receivedQty + bonusQty) * actualPrice;
  }

  Future<void> _selectExpirationDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.products[index]['expirationDate'] as DateTime? ??
          DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (picked != null) {
      _updateProduct(index, 'expirationDate', picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    final theme = Theme.of(context);
    final product = widget.products[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Are you sure you want to remove this product from the invoice?'),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'medication',
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      product['name'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              widget.onProductRemoved(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
