import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

import 'package:teriak/config/themes/app_icon.dart';
import './widgets/order_header_card.dart';
import './widgets/product_item_card.dart';
import './widgets/supplier_info_card.dart';
import './widgets/total_amount_card.dart';

class PurchaseOrderDetail extends StatefulWidget {
  const PurchaseOrderDetail({super.key});

  @override
  State<PurchaseOrderDetail> createState() => _PurchaseOrderDetailState();
}

class _PurchaseOrderDetailState extends State<PurchaseOrderDetail> {
  bool _isLoading = false;
  Map<String, dynamic>? _orderData;

  // Mock data for purchase order details
  final Map<String, dynamic> _mockOrderData = {
    "orderId": "PO-2025-001",
    "orderName": "طلبية أدوية الصيدلية المركزية",
    "status": "pending",
    "createdDate": "2025-01-15T10:30:00Z",
    "currency": "SYP",
    "supplier": {
      "id": "SUP-001",
      "name": "شركة الأدوية السورية المحدودة",
      "phone": "+963-11-2234567",
      "email": "info@syrianpharma.com",
      "address": "شارع بغداد، دمشق، سوريا"
    },
    "products": [
      {
        "id": "PROD-001",
        "name": "باراسيتامول 500 ملغ",
        "description": "مسكن للألم وخافض للحرارة، علبة 20 قرص",
        "image":
            "https://images.pexels.com/photos/3683074/pexels-photo-3683074.jpeg",
        "quantity": 50,
        "unit": "علبة",
        "unitPrice": 250.0
      },
      {
        "id": "PROD-002",
        "name": "أموكسيسيلين 250 ملغ",
        "description": "مضاد حيوي واسع الطيف، علبة 14 كبسولة",
        "image":
            "https://images.pexels.com/photos/3683073/pexels-photo-3683073.jpeg",
        "quantity": 30,
        "unit": "علبة",
        "unitPrice": 450.0
      },
      {
        "id": "PROD-003",
        "name": "فيتامين د3 1000 وحدة",
        "description": "مكمل غذائي لتقوية العظام، علبة 30 كبسولة",
        "image":
            "https://images.pexels.com/photos/3683056/pexels-photo-3683056.jpeg",
        "quantity": 25,
        "unit": "علبة",
        "unitPrice": 180.0
      },
      {
        "id": "PROD-004",
        "name": "شراب السعال للأطفال",
        "description": "شراب طبيعي لعلاج السعال، زجاجة 120 مل",
        "image":
            "https://images.pexels.com/photos/3683040/pexels-photo-3683040.jpeg",
        "quantity": 20,
        "unit": "زجاجة",
        "unitPrice": 320.0
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _loadOrderData();
  }

  Future<void> _loadOrderData() async {
    setState(() => _isLoading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _orderData = _mockOrderData;
      _isLoading = false;
    });
  }

  Future<void> _refreshOrderData() async {
    HapticFeedback.lightImpact();
    await _loadOrderData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _isLoading ? _buildLoadingState(context) : _buildContent(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      elevation: 2,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back_ios',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'تفاصيل الطلبية',
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'edit',
            color: theme.colorScheme.onPrimary,
            size: 24,
          ),
          onPressed: () => _navigateToEdit(context),
          tooltip: 'تعديل الطلبية',
        ),
        PopupMenuButton<String>(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: theme.colorScheme.onPrimary,
            size: 24,
          ),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'share',
              child: ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
                title: const Text('مشاركة'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'duplicate',
              child: ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
                title: const Text('نسخ الطلبية'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                title: Text(
                  'حذف الطلبية',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'جاري تحميل تفاصيل الطلبية...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_orderData == null) {
      return _buildErrorState(context);
    }

    return RefreshIndicator(
      onRefresh: _refreshOrderData,
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),

            // Order Header Card
            OrderHeaderCard(orderData: _orderData!),

            // Supplier Information Card
            SupplierInfoCard(
              supplierData:
                  (_orderData!['supplier'] as Map<String, dynamic>?) ?? {},
              currency: _orderData!['currency'] as String? ?? 'SYP',
            ),

            // Products Section Header
            _buildSectionHeader(context, 'المنتجات المطلوبة'),

            // Product Items List
            ..._buildProductsList(context),

            SizedBox(height: 2.h),

            // Total Amount Card (Sticky at bottom)
            TotalAmountCard(
              products: (_orderData!['products'] as List<dynamic>?)
                      ?.cast<Map<String, dynamic>>() ??
                  [],
              currency: _orderData!['currency'] as String? ?? 'SYP',
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'error_outline',
              color: theme.colorScheme.error,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'خطأ في تحميل البيانات',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'حدث خطأ أثناء تحميل تفاصيل الطلبية. يرجى المحاولة مرة أخرى.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: _loadOrderData,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildProductsList(BuildContext context) {
    final products = (_orderData!['products'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    if (products.isEmpty) {
      return [_buildEmptyProductsState(context)];
    }

    return products.map((product) {
      return ProductItemCard(
        productData: product,
        currency: _orderData!['currency'] as String? ?? 'SYP',
        onLongPress: () => _showProductContextMenu(context, product),
      );
    }).toList();
  }

  Widget _buildEmptyProductsState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'inventory_2',
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'لا توجد منتجات في هذه الطلبية',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/edit-purchase-order',
      arguments: _orderData,
    ).then((result) {
      if (result == true) {
        _refreshOrderData();
      }
    });
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'share':
        _shareOrderDetails(context);
        break;
      case 'duplicate':
        _duplicateOrder(context);
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _shareOrderDetails(BuildContext context) {
    final orderName = _orderData!['orderName'] as String? ?? 'طلبية غير محددة';
    final orderId = _orderData!['orderId'] as String? ?? 'غير محدد';

    // TODO: Implement actual sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('مشاركة تفاصيل الطلبية: $orderName ($orderId)'),
        action: SnackBarAction(
          label: 'موافق',
          onPressed: () {},
        ),
      ),
    );
  }

  void _duplicateOrder(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/create-purchase-order',
      arguments: {'duplicateFrom': _orderData},
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: theme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('تأكيد الحذف'),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من حذف هذه الطلبية؟ لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteOrder(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _deleteOrder(BuildContext context) {
    // TODO: Implement actual delete functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف الطلبية بنجاح'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/purchase-order-list',
      (route) => false,
    );
  }

  void _showProductContextMenu(
      BuildContext context, Map<String, dynamic> product) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              product['name'] as String? ?? 'منتج غير محدد',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              title: const Text('عرض التفاصيل'),
              onTap: () {
                Navigator.pop(context);
                _showProductDetails(context, product);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: theme.colorScheme.secondary,
                size: 24,
              ),
              title: const Text('تعديل المنتج'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to product edit
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تعديل المنتج قريباً')),
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          product['name'] as String? ?? 'منتج غير محدد',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (product['description'] != null) ...[
                Text(
                  'الوصف:',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  product['description'] as String,
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
              ],
              Text(
                'الكمية: ${product['quantity'] ?? 0} ${product['unit'] ?? ''}',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                'سعر الوحدة: ${product['unitPrice'] ?? 0} ${_getCurrencySymbol(_orderData!['currency'] as String? ?? 'SYP')}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toLowerCase()) {
      case 'syp':
      case 'syrian pound':
        return 'ل.س';
      case 'usd':
      case 'us dollar':
        return '\$';
      default:
        return currency;
    }
  }
}
