import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart' show AppPages;
import 'package:teriak/config/themes/app_icon.dart';

import './widgets/paid_invoices_list_widget.dart';
import './widgets/purchase_order_dropdown_widget.dart';

class PurchaseOrderSelectionScreen extends StatefulWidget {
  const PurchaseOrderSelectionScreen({super.key});

  @override
  State<PurchaseOrderSelectionScreen> createState() =>
      _PurchaseOrderSelectionScreenState();
}

class _PurchaseOrderSelectionScreenState
    extends State<PurchaseOrderSelectionScreen> {
  String? _selectedPurchaseOrder;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isRefreshing = false;
  String _searchQuery = '';

  // Mock data for purchase orders
  final List<Map<String, dynamic>> _purchaseOrders = [
    {
      "id": "PO001",
      "poNumber": "PO-2024-001",
      "supplier": "شركة الإلكترونيات العالمية",
      "date": "2024-08-05",
      "status": "معتمد",
      "itemCount": 3,
      "totalAmount": 5049.47,
    },
    {
      "id": "PO002",
      "poNumber": "PO-2024-002",
      "supplier": "شركة المكونات المتميزة",
      "date": "2024-08-07",
      "status": "معتمد",
      "itemCount": 2,
      "totalAmount": 4649.73,
    },
    {
      "id": "PO003",
      "poNumber": "PO-2024-003",
      "supplier": "حلول التقنية أوروبا",
      "date": "2024-08-08",
      "status": "معتمد",
      "itemCount": 3,
      "totalAmount": 3198.23,
    },
  ];

  // Mock data for paid invoices
  final List<Map<String, dynamic>> _paidInvoices = [
    {
      "id": "INV001",
      "invoiceNumber": "INV-2024-001",
      "supplier": "شركة الإلكترونيات العالمية",
      "date": "2024-08-10",
      "totalAmount": 2584.50,
      "currency": "USD",
      "status": "مدفوع",
      "paymentDate": "2024-08-12",
    },
    {
      "id": "INV002",
      "invoiceNumber": "INV-2024-002",
      "supplier": "شركة المكونات المتميزة",
      "date": "2024-08-09",
      "totalAmount": 1879.95,
      "currency": "USD",
      "status": "مدفوع",
      "paymentDate": "2024-08-11",
    },
    {
      "id": "INV003",
      "invoiceNumber": "INV-2024-003",
      "supplier": "حلول التقنية أوروبا",
      "date": "2024-08-08",
      "totalAmount": 3456.78,
      "currency": "EUR",
      "status": "مدفوع",
      "paymentDate": "2024-08-10",
    },
    {
      "id": "INV004",
      "invoiceNumber": "INV-2024-004",
      "supplier": "شركة الإلكترونيات العالمية",
      "date": "2024-08-07",
      "totalAmount": 956.25,
      "currency": "USD",
      "status": "مدفوع",
      "paymentDate": "2024-08-09",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onPurchaseOrderSelected(String? poId) {
    if (poId != null) {
      setState(() {
        _selectedPurchaseOrder = poId;
      });

      Get.toNamed(
        AppPages.enhancedCreateInvoice,
        arguments: {
          'purchaseOrderId': poId,
          'purchaseOrder': _purchaseOrders.firstWhere((po) => po['id'] == poId),
        },
      );
    }
  }

  void _onInvoiceSelected(Map<String, dynamic> invoice) {
    Get.toNamed(
      AppPages.invoiceDetail,
      arguments: invoice,
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // In real implementation, refresh data from API
      setState(() {
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() {
        _isRefreshing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('فشل في تحديث البيانات'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<Map<String, dynamic>> get _filteredInvoices {
    if (_searchQuery.isEmpty) {
      return _paidInvoices;
    }

    return _paidInvoices.where((invoice) {
      return invoice['invoiceNumber'].toLowerCase().contains(_searchQuery) ||
          invoice['supplier'].toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة فواتير الشراء'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      theme.colorScheme.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'inventory_2',
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'مرحباً بك في نظام إدارة فواتير الشراء',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'اختر طلب شراء لإنشاء فاتورة جديدة، أو تصفح الفواتير المدفوعة أدناه',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Purchase Order Selection
              PurchaseOrderDropdownWidget(
                purchaseOrders: _purchaseOrders,
                selectedPurchaseOrder: _selectedPurchaseOrder,
                onPurchaseOrderSelected: _onPurchaseOrderSelected,
                isLoading: _isLoading,
              ),

              SizedBox(height: 4.h),

              // Paid Invoices Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الفواتير المدفوعة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredInvoices.length} فاتورة',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText:
                        'البحث في الفواتير برقم الفاتورة أو اسم المورد...',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Paid Invoices List
              PaidInvoicesListWidget(
                invoices: _filteredInvoices,
                onInvoiceSelected: _onInvoiceSelected,
                isRefreshing: _isRefreshing,
              ),

              SizedBox(height: 8.h), // Extra space for better scrolling
            ],
          ),
        ),
      ),
    );
  }
}
