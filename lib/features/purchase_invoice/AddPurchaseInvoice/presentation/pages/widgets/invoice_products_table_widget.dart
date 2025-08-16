import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class InvoiceProductsTableWidget extends StatefulWidget {
  final String currency;
  final List<Map<String, dynamic>> products;
  final String searchQuery;
  final Function(int, Map<String, dynamic>) onProductDataChanged;

  const InvoiceProductsTableWidget({
    super.key,
    required this.currency,
    required this.products,
    required this.searchQuery,
    required this.onProductDataChanged,
  });

  @override
  State<InvoiceProductsTableWidget> createState() =>
      _InvoiceProductsTableWidgetState();
}

class _InvoiceProductsTableWidgetState
    extends State<InvoiceProductsTableWidget> {
  @override
  void didUpdateWidget(InvoiceProductsTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تحديث الواجهة عند تغيير البيانات
    if (oldWidget.products != widget.products ||
        oldWidget.searchQuery != widget.searchQuery) {
      setState(() {});
    }
  }

  bool _isProductHighlighted(Map<String, dynamic> product, String query) {
    if (query.isEmpty) return false;

    return product['name'].toLowerCase().contains(query.toLowerCase()) ||
        product['barcode'].toLowerCase().contains(query.toLowerCase());
  }

  double _calculateActualUnitPrice(Map<String, dynamic> product) {
    final receivedQty = product['receivedQty'] as int;
    final bonusQty = product['bonusQty'] as int;
    final invoicePrice = product['invoicePrice'] as double;

    if (receivedQty == 0) return invoicePrice;

    final totalQty = receivedQty + bonusQty;
    if (totalQty == 0) return invoicePrice;

    // Calculate unit cost including bonus adjustment
    return (receivedQty * invoicePrice) / totalQty;
  }

  void _updateProductData(int index, String field, dynamic value) {
    final updatedProduct = {...widget.products[index], field: value};

    // تحديث سعر الشراء الفعلي تلقائياً إذا تم تغيير الكمية أو السعر
    if (field == 'receivedQty' ||
        field == 'bonusQty' ||
        field == 'invoicePrice') {
      final actualPrice = _calculateActualUnitPrice(updatedProduct);
      updatedProduct['actualPrice'] = actualPrice;
    }

    widget.onProductDataChanged(index, updatedProduct);

    // تحديث الواجهة
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.products.isEmpty) {
      return Container(
          width: double.infinity,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3))),
          child: Column(children: [
            CustomIconWidget(
                iconName: 'inventory_2',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 64),
            SizedBox(height: 2.h),
            Text('No Products'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 1.h),
            Text('No Products Found'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                textAlign: TextAlign.center),
          ]));
    }

    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.products.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final product = widget.products[index];
          final isHighlighted =
              _isProductHighlighted(product, widget.searchQuery);

          return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  color: isHighlighted
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isHighlighted
                          ? theme.colorScheme.primary.withValues(alpha: 0.5)
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isHighlighted ? 2 : 1),
                  boxShadow: [
                    BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2)),
                  ]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Header
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8)),
                              child: CustomIconWidget(
                                  iconName: 'inventory_2',
                                  color: theme.colorScheme.primary,
                                  size: 20)),
                          SizedBox(width: 3.w),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(product['name'],
                                    style: theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isHighlighted
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface)),
                                SizedBox(height: 0.5.h),
                                SizedBox(width: 2.w),
                                Text('${'Barcode'.tr}: ${product['barcode']}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.7))),
                              ])),
                        ]),

                    SizedBox(height: 2.h),

                    // Required Quantity & Unit Price (Read-only)
                    Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Required Quantity'.tr,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.7))),
                                Text('${product['requiredQuantity']}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600)),
                              ])),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text('Actual Purchase Price'.tr,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.7))),
                                Text(
                                    '${widget.currency}${NumberFormat('#,##0.00').format(product['actualPrice'])}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.primary)),
                              ])),
                        ])),

                    SizedBox(height: 2.h),

                    // Input Fields Grid
                    _buildInputFieldsGrid(context, product, index),
                  ]));
        });
  }

  Widget _buildInputFieldsGrid(
      BuildContext context, Map<String, dynamic> product, int index) {
    final theme = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Receipt Data'.tr,
          style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
      SizedBox(height: 1.h),

      // Row 1: Received Quantity & Bonus Quantity
      Row(children: [
        Expanded(
            child: _buildNumberField(
                context, '${'Received Quantity'.tr} *', product['receivedQty'],
                (value) {
          _updateProductData(index, 'receivedQty', value);
        }, isRequired: true)),
        SizedBox(width: 2.w),
        Expanded(
            child: _buildNumberField(
          context,
          'Bonus Quantity'.tr,
          product['bonusQty'],
          (value) {
            _updateProductData(index, 'bonusQty', value);
          },
        )),
      ]),

      SizedBox(height: 2.h),

      // Row 2: Min Stock Level & Batch Number
      Row(children: [
        Expanded(
            child: _buildNumberField(
                context,
                'Min Stock Level'.tr,
                product['minStockLevel'],
                (value) => _updateProductData(index, 'minStockLevel', value))),
        SizedBox(width: 2.w),
        Expanded(
            child: _buildTextField(
                context,
                'Batch Number'.tr,
                product['batchNo'],
                (value) => _updateProductData(index, 'batchNo', value))),
      ]),

      SizedBox(height: 2.h),

      // Row 3: Expiry Date & Actual Purchase Price
      Row(children: [
        Expanded(
            child: _buildDateField(
          context,
          'Expiry Date'.tr,
          product['expiryDate'],
          (value) => _updateProductData(index, 'expiryDate', value),
        )),
        SizedBox(width: 2.w),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${'Unit Price'.tr} *',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8))),
          SizedBox(height: 0.5.h),
          (product['productType'] == 'MASTER' ||
                  product['productType'] == 'مركزي')
              ? Text(
                  '${widget.currency}${NumberFormat('#,##0.00').format(product['invoicePrice'])}',
                  style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary),
                )
              : TextFormField(
                  initialValue: product['invoicePrice'].toString(),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      isDense: true,
                      prefixText: widget.currency,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 1.5.h),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        double.tryParse(value) == 0) {
                      return 'Required'.tr;
                    }
                  },
                  onChanged: (val) {
                    final doubleValue = double.tryParse(val) ?? 0.0;
                    _updateProductData(index, 'invoicePrice', doubleValue);
                  },
                ),
        ])),
      ]),
    ]);
  }

  Widget _buildNumberField(
    BuildContext context,
    String label,
    dynamic value,
    Function(int) onChanged, {
    bool isRequired = false,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8))),
      SizedBox(height: 0.5.h),
      TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          onChanged: (val) {
            final intValue = int.tryParse(val) ?? 0;
            onChanged(intValue);
          },
          validator: isRequired
              ? (value) {
                  if (value == null ||
                      value.trim().isEmpty ||
                      int.tryParse(value) == 0) {
                    return 'Required'.tr;
                  }
                  return null;
                }
              : null),
    ]);
  }

  Widget _buildTextField(BuildContext context, String label, String value,
      Function(String) onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8))),
      SizedBox(height: 0.5.h),
      TextFormField(
          initialValue: value,
          decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          onChanged: onChanged),
    ]);
  }

  Widget _buildDateField(BuildContext context, String label, DateTime? value,
      Function(DateTime?) onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8))),
      SizedBox(height: 0.5.h),
      InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
                context: context,
                initialDate:
                    value ?? DateTime.now().add(const Duration(days: 365)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 3650)));
            if (selectedDate != null) {
              onChanged(selectedDate);
              // تحديث الواجهة بعد اختيار التاريخ
              setState(() {});
            }
          },
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                CustomIconWidget(
                    iconName: 'calendar_today',
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                    size: 16),
                SizedBox(width: 2.w),
                Text(
                    value != null
                        ? DateFormat('dd/MM/yyyy').format(value)
                        : 'Choose Date'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: value != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6))),
              ]))),
    ]);
  }
}
