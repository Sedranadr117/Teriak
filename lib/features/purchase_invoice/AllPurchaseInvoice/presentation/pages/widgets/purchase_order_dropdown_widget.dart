import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class PurchaseOrderDropdownWidget extends StatelessWidget {
  final List<Map<String, dynamic>> purchaseOrders;
  final String? selectedPurchaseOrder;
  final Function(String?) onPurchaseOrderSelected;
  final bool isLoading;

  const PurchaseOrderDropdownWidget({
    super.key,
    required this.purchaseOrders,
    required this.selectedPurchaseOrder,
    required this.onPurchaseOrderSelected,
    this.isLoading = false,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Section Title
      Row(children: [
        CustomIconWidget(
            iconName: 'assignment', color: theme.colorScheme.primary, size: 24),
        SizedBox(width: 2.w),
        Text('اختيار طلب الشراء',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
      ]),
      SizedBox(height: 1.h),
      Text('اختر طلب شراء لإنشاء فاتورة شراء جديدة',
          style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
      SizedBox(height: 2.h),

      // Dropdown Container
      Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1),
              boxShadow: [
                BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ]),
          child: isLoading
              ? Container(
                  padding: EdgeInsets.all(4.w),
                  child: Row(children: [
                    SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary))),
                    SizedBox(width: 3.w),
                    Text('جارٍ تحميل طلبات الشراء...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7))),
                  ]))
              : DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedPurchaseOrder,
                      hint: Container(
                          padding: EdgeInsets.all(4.w),
                          child: Row(children: [
                            CustomIconWidget(
                                iconName: 'keyboard_arrow_down',
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                                size: 24),
                            SizedBox(width: 3.w),
                            Expanded(
                                child: Text('اختر طلب شراء لإنشاء فاتورة...',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6)))),
                          ])),
                      items: purchaseOrders.map<DropdownMenuItem<String>>((po) {
                        return DropdownMenuItem<String>(
                            value: po['id'],
                            child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Text(po['poNumber'],
                                                    style: theme
                                                        .textTheme.titleSmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: theme
                                                                .colorScheme
                                                                .primary))),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 0.5.h),
                                                decoration: BoxDecoration(
                                                    color: theme
                                                        .colorScheme.tertiary
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                                child: Text(po['status'],
                                                    style: theme
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                            color: theme
                                                                .colorScheme
                                                                .tertiary,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                          ]),
                                      SizedBox(height: 0.5.h),
                                      Text(po['supplier'],
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500)),
                                      SizedBox(height: 0.5.h),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              CustomIconWidget(
                                                  iconName: 'calendar_today',
                                                  color: theme
                                                      .colorScheme.onSurface
                                                      .withValues(alpha: 0.6),
                                                  size: 16),
                                              SizedBox(width: 1.w),
                                              Text(_formatDate(po['date']),
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: theme
                                                              .colorScheme
                                                              .onSurface
                                                              .withValues(
                                                                  alpha: 0.7))),
                                            ]),
                                            Row(children: [
                                              CustomIconWidget(
                                                  iconName: 'inventory_2',
                                                  color: theme
                                                      .colorScheme.onSurface
                                                      .withValues(alpha: 0.6),
                                                  size: 16),
                                              SizedBox(width: 1.w),
                                              Text('${po['itemCount']} منتجات',
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: theme
                                                              .colorScheme
                                                              .onSurface
                                                              .withValues(
                                                                  alpha: 0.7))),
                                            ]),
                                            Row(children: [
                                              CustomIconWidget(
                                                  iconName: 'attach_money',
                                                  color: theme
                                                      .colorScheme.onSurface
                                                      .withValues(alpha: 0.6),
                                                  size: 16),
                                              SizedBox(width: 1.w),
                                              Text(
                                                  '\$${_formatCurrency(po['totalAmount'])}',
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          color: theme
                                                              .colorScheme
                                                              .primary,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                            ]),
                                          ]),
                                    ])));
                      }).toList(),
                      onChanged: onPurchaseOrderSelected,
                      isExpanded: true,
                      icon: Container(
                          margin: EdgeInsets.only(right: 2.w),
                          child: CustomIconWidget(
                              iconName: 'keyboard_arrow_down',
                              color: theme.colorScheme.primary,
                              size: 24)),
                      dropdownColor: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 8,
                      menuMaxHeight: 50.h))),

      // Quick Action Buttons
      if (purchaseOrders.isNotEmpty) ...[
        SizedBox(height: 2.h),
        Row(children: [
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to purchase order list or management screen
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('ستتم إضافة إدارة طلبات الشراء قريباً')));
                  },
                  icon: CustomIconWidget(
                      iconName: 'view_list',
                      color: theme.colorScheme.primary,
                      size: 18),
                  label: const Text('عرض جميع الطلبات'),
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h)))),
          SizedBox(width: 2.w),
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to create new purchase order screen
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('ستتم إضافة إنشاء طلب شراء جديد قريباً')));
                  },
                  icon: CustomIconWidget(
                      iconName: 'add',
                      color: theme.colorScheme.primary,
                      size: 18),
                  label: const Text('طلب جديد'),
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h)))),
        ]),
      ],
    ]);
  }
}
