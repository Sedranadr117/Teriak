import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/Sales_management/presentation/pages/single_sale_screen.dart';

class MultiSalesScreen extends StatefulWidget {
  const MultiSalesScreen({super.key});

  @override
  _MultiSalesScreenState createState() => _MultiSalesScreenState();
}

class _MultiSalesScreenState extends State<MultiSalesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _salesTabs = [
    {
      'id': '1',
      'name': 'Sale Tab'.tr,
      'icon': Icons.shopping_cart_outlined,
      'color': AppColors.backgroundColor,
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _salesTabs.length, vsync: this);
  }

  void _addNewSale() {
    setState(() {
      final newId = (_salesTabs.length + 1).toString();
      _salesTabs.add({
        'id': newId,
        'name': 'Sale Tab'.tr,
        'icon': Icons.shopping_cart_outlined,
        'color': AppColors.backgroundColor,
      });
      _tabController = TabController(
        length: _salesTabs.length,
        vsync: this,
      )..index = _salesTabs.length - 1;
    });
  }

  void _closeSale(int index, BuildContext context) {
    if (_salesTabs.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('At least one sale session must remain open'.tr),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warningLight,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text('Close Sale Session'.tr),
              ],
            ),
            content: Text(
                'Are you sure you want to close this sale session? Any unsaved data will be lost.'
                    .tr),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _salesTabs.removeAt(index);
                    _tabController = TabController(
                      length: _salesTabs.length,
                      vsync: this,
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close Session'.tr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ],
          );
        });
  }

  void _closeCurrentTab(int index) {
    if (_salesTabs.length > 1) {
      setState(() {
        _salesTabs.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3.h),
          child: SizedBox(
            height: 50,
            child: TabBar(
              indicator: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: List.generate(_salesTabs.length, (index) {
                final tab = _salesTabs[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tab['icon'],
                          size: 18,
                          color: tab['color'],
                        ),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            '${tab['name'.tr]}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: tab['color'],
                                ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        if (_salesTabs.length > 1)
                          GestureDetector(
                            onTap: () => _closeSale(index, context),
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _addNewSale,
              icon: Icon(Icons.add, size: 24),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_salesTabs.length, (index) {
          return SingleSaleScreen(
            tabId: _salesTabs[index]['id'],
            onSaleCompleted: () => _closeCurrentTab(index),
          );
        }),
      ),
    );
  }
}
