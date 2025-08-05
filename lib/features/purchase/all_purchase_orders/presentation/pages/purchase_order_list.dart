import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';

import './widgets/empty_state_widget.dart';
import './widgets/header_widget.dart';
import './widgets/purchase_order_card.dart';
import './widgets/search_bar_widget.dart';

class PurchaseOrderList extends StatefulWidget {
  const PurchaseOrderList({super.key});

  @override
  State<PurchaseOrderList> createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends State<PurchaseOrderList>
    with TickerProviderStateMixin {
  bool _isDarkMode = false;
  String _searchQuery = '';
  bool _isLoading = false;
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  // Mock purchase orders data
  final List<Map<String, dynamic>> _allOrders = [
    {
      "id": 1,
      "orderName": "طلب شراء المواد الطبية",
      "supplierName": "شركة الأدوية المتقدمة",
      "totalAmount": 2500000.0,
      "currency": "SYP",
      "creationDate": "15/07/2025",
      "status": "pending",
      "products": [
        {"name": "أقراص باراسيتامول", "quantity": 100, "price": 15000.0},
        {"name": "شراب السعال", "quantity": 50, "price": 25000.0}
      ]
    },
    {
      "id": 2,
      "orderName": "طلب أجهزة طبية",
      "supplierName": "مؤسسة التقنيات الطبية",
      "totalAmount": 850.0,
      "currency": "USD",
      "creationDate": "12/07/2025",
      "status": "completed",
      "products": [
        {"name": "جهاز قياس الضغط", "quantity": 5, "price": 120.0},
        {"name": "ميزان حرارة رقمي", "quantity": 10, "price": 25.0}
      ]
    },
    {
      "id": 3,
      "orderName": "مستلزمات العيادة",
      "supplierName": "شركة المستلزمات الطبية",
      "totalAmount": 1200000.0,
      "currency": "SYP",
      "creationDate": "10/07/2025",
      "status": "completed",
      "products": [
        {"name": "قفازات طبية", "quantity": 200, "price": 5000.0},
        {"name": "كمامات جراحية", "quantity": 500, "price": 2000.0}
      ]
    },
    {
      "id": 4,
      "orderName": "أدوية القلب والأوعية",
      "supplierName": "دار الدواء الحديثة",
      "totalAmount": 3200000.0,
      "currency": "SYP",
      "creationDate": "08/07/2025",
      "status": "pending",
      "products": [
        {"name": "أقراص الضغط", "quantity": 150, "price": 18000.0},
        {"name": "كبسولات القلب", "quantity": 80, "price": 22000.0}
      ]
    },
    {
      "id": 5,
      "orderName": "معدات التشخيص",
      "supplierName": "شركة التكنولوجيا الطبية",
      "totalAmount": 1500.0,
      "currency": "USD",
      "creationDate": "05/07/2025",
      "status": "cancelled",
      "products": [
        {"name": "جهاز تخطيط القلب", "quantity": 1, "price": 1200.0},
        {"name": "جهاز الموجات فوق الصوتية", "quantity": 1, "price": 300.0}
      ]
    },
    {
      "id": 6,
      "orderName": "أدوية الأطفال",
      "supplierName": "صيدلية الأطفال المتخصصة",
      "totalAmount": 800000.0,
      "currency": "SYP",
      "creationDate": "03/07/2025",
      "status": "completed",
      "products": [
        {"name": "شراب خافض الحرارة للأطفال", "quantity": 60, "price": 12000.0},
        {"name": "قطرات الأنف للرضع", "quantity": 40, "price": 8000.0}
      ]
    }
  ];

  List<Map<String, dynamic>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filteredOrders = List.from(_allOrders);
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _filterOrders(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredOrders = List.from(_allOrders);
      } else {
        _filteredOrders = _allOrders.where((order) {
          final orderName = (order['orderName'] as String).toLowerCase();
          final supplierName = (order['supplierName'] as String).toLowerCase();
          final searchLower = query.toLowerCase();
          return orderName.contains(searchLower) ||
              supplierName.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _isLoading = true;
    });

    _refreshController.forward();
    HapticFeedback.lightImpact();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
      // In real app, this would fetch fresh data
      _filteredOrders = List.from(_allOrders);
    });

    _refreshController.reset();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث قائمة الطلبات'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToOrderDetail(Map<String, dynamic> order) {
    HapticFeedback.selectionClick();
    Get.toNamed(
      AppPages.purchaseOrderDetail,
      arguments: order,
    );
  }

  void _navigateToEditOrder(Map<String, dynamic> order) {
    HapticFeedback.selectionClick();
    Get.toNamed(
      AppPages.editPurchaseOrder,
      arguments: order,
    );
  }

  void _duplicateOrder(Map<String, dynamic> order) {
    HapticFeedback.lightImpact();
    final duplicatedOrder = Map<String, dynamic>.from(order);
    duplicatedOrder['id'] = _allOrders.length + 1;
    duplicatedOrder['orderName'] = '${order['orderName']} - نسخة';
    duplicatedOrder['creationDate'] = '05/08/2025';
    duplicatedOrder['status'] = 'pending';

    setState(() {
      _allOrders.insert(0, duplicatedOrder);
      _filterOrders(_searchQuery);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ الطلب بنجاح'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteOrder(Map<String, dynamic> order) {
    HapticFeedback.heavyImpact();
    setState(() {
      _allOrders.removeWhere((item) => item['id'] == order['id']);
      _filterOrders(_searchQuery);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حذف الطلب'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {
            setState(() {
              _allOrders.add(order);
              _filterOrders(_searchQuery);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _navigateToCreateOrder() {
    HapticFeedback.selectionClick();
    Get.toNamed(AppPages.createPurchaseOrder);
  }

  void _toggleTheme() {
    HapticFeedback.lightImpact();
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _clearSearch() {
    _filterOrders('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          HeaderWidget(
            title: 'إدارة طلبات الشراء',
            subtitle: 'إدارة وتتبع جميع طلبات الشراء',
            onThemeToggle: _toggleTheme,
            isDarkMode: _isDarkMode,
          ),
          SizedBox(height: 1.h),
          SearchBarWidget(
            hintText: 'البحث في الطلبات...',
            onSearchChanged: _filterOrders,
            onClear: _clearSearch,
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _filteredOrders.isEmpty
                    ? _buildEmptyState()
                    : _buildOrdersList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateOrder,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'طلب جديد',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _refreshAnimation,
            child: CustomIconWidget(
              iconName: 'refresh',
              size: 12.w,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'جاري تحديث الطلبات...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        title: 'لا توجد نتائج',
        subtitle: 'لم يتم العثور على طلبات تطابق البحث "${_searchQuery}"',
        buttonText: 'مسح البحث',
        onButtonPressed: _clearSearch,
        isSearchResult: true,
      );
    }

    return EmptyStateWidget(
      title: 'لا توجد طلبات شراء',
      subtitle: 'ابدأ بإنشاء أول طلب شراء لك\nلإدارة المخزون والموردين بكفاءة',
      buttonText: 'إنشاء طلب جديد',
      onButtonPressed: _navigateToCreateOrder,
    );
  }

  Widget _buildOrdersList() {
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];
          return PurchaseOrderCard(
            orderData: order,
            onTap: () => _navigateToOrderDetail(order),
            onEdit: () => _navigateToEditOrder(order),
            onDuplicate: () => _duplicateOrder(order),
            onDelete: () => _deleteOrder(order),
          );
        },
      ),
    );
  }
}
