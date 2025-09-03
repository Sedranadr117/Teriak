import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/widgets/custom_binding_widget.dart';
import 'package:teriak/features/money_box/data/models/money_box_model.dart';
import 'package:teriak/features/money_box/presentation/controller/get_money_box_controlller.dart';
import 'package:teriak/features/money_box/presentation/controller/get_money_box_transaction_controlller.dart';
import 'package:teriak/features/money_box/presentation/pages/add_transaction_dialog.dart';
import 'package:teriak/features/money_box/presentation/pages/add_reconcile_dialog.dart';

class MoneyBoxInfoPage extends StatefulWidget {
  const MoneyBoxInfoPage({super.key});

  @override
  State<MoneyBoxInfoPage> createState() => _MoneyBoxInfoPageState();
}

class _MoneyBoxInfoPageState extends State<MoneyBoxInfoPage> {
  final moneyBoxController = Get.put(GetMoneyBoxController());
  final transactionsController = Get.put(GetMoneyBoxTransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Box Information'.tr),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              moneyBoxController.refreshData();
              transactionsController.refreshData();
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Get.dialog(AddTransactionDialog());
            },
            icon: Icon(Icons.add),
            tooltip: 'Add Transaction'.tr,
          ),
          IconButton(
            onPressed: () {
              Get.dialog(AddReconcileDialog());
            },
            icon: Icon(Icons.account_balance_wallet),
            tooltip: 'Reconcile Money Box'.tr,
          ),
        ],
      ),
      body: Column(
        children: [
          // // Fixed Pharmacy Name
          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          //   decoration: BoxDecoration(
          //     color: AppColors.primaryLight,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.1),
          //         blurRadius: 4,
          //         offset: Offset(0, 2),
          //       ),
          //     ],
          //   ),
          //   child: Text(
          //     'Pharmacy Name', // This should be fetched from pharmacy settings
          //     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //           color: AppColors.textPrimaryLight,
          //           fontWeight: FontWeight.bold,
          //         ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),

          // SizedBox(height: 2.h),

          // Money Box Information Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _buildMoneyBoxInfoCard(),
          ),

          // Transactions List
          Expanded(
            child: _buildTransactionsList(),
          ),

          // Pagination Info
          Obx(() {
            if (transactionsController.transactions.value?.totalElements !=
                    null &&
                transactionsController.transactions.value!.totalElements > 0) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${'Total'.tr}: ${transactionsController.transactions.value!.totalElements} ${'transactions'.tr}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${'Page'.tr} ${transactionsController.currentPage.value + 1} ${'of'.tr} ${transactionsController.transactions.value!.totalPages}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildMoneyBoxInfoCard() {
    return Obx(() {
      if (moneyBoxController.isLoading.value) {
        return Card(
          child: Container(
            height: 20.h,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      if (moneyBoxController.errorMessage.value.isNotEmpty) {
        return Card(
            child: CommonWidgets.buildErrorWidget(
          context: context,
          errorMessage: moneyBoxController.errorMessage.value,
          onPressed: moneyBoxController.refreshData,
        ));
      }

      final moneyBox = moneyBoxController.moneyBox.value as MoneyBoxModel;
      if (moneyBox == null) {
        return Card(
          child: Container(
            height: 20.h,
            child: Center(
              child: Text(
                'No money box data available',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        );
      }

      return Card(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Money Box Information'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 1.h),
              _buildInfoRow('Status'.tr, moneyBox.status),
              _buildInfoRow('Last Reconciled'.tr, moneyBox.formattedCreationDateTime),
              _buildInfoRow('Total Balance (SYP)'.tr,
                  '${moneyBox.totalBalanceInSYP.toStringAsFixed(2)} SYP'),
              _buildInfoRow('Total Balance (USD)'.tr,
                  '${moneyBox.totalBalanceInUSD.toStringAsFixed(2)} USD'),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Obx(() {
      if (transactionsController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (transactionsController.errorMessage.value.isNotEmpty) {
        return Center(
            child: CommonWidgets.buildErrorWidget(
          context: context,
          errorMessage: transactionsController.errorMessage.value,
          onPressed: transactionsController.refreshData,
        ));
      }

      final transactions = transactionsController.transactions.value;
      if (transactions == null || transactions.content.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: 48,
                color: AppColors.textSecondaryLight.withOpacity(0.5),
              ),
              SizedBox(height: 2.h),
              Text(
                'No transactions found'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Transactions will appear here once created'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondaryLight.withOpacity(0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: AppColors.primaryLight,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Money Box Transactions'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLight,
                      ),
                ),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: ListView.builder(
              itemCount: transactions.content.length,
              itemBuilder: (context, index) {
                final transaction = transactions.content[index];
                return _buildTransactionCard(transaction);
              },
            ),
          ),

          // Pagination Controls
          if (transactions.totalPages > 1)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: transactions.hasPrevious
                        ? transactionsController.previousPage
                        : null,
                    icon: Icon(Icons.chevron_left),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${transactionsController.currentPage.value + 1} / ${transactions.totalPages}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: transactions.hasNext
                        ? transactionsController.nextPage
                        : null,
                    icon: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  Widget _buildTransactionCard(dynamic transaction) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.transactionType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            transaction.amount >= 0 ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            _buildTransactionInfoRow('Balance Before'.tr,
                '${transaction.balanceBefore.toStringAsFixed(2)}'),
            _buildTransactionInfoRow('Balance After'.tr,
                '${transaction.balanceAfter.toStringAsFixed(2)}'),
            if (transaction.description.isNotEmpty)
              _buildTransactionInfoRow(
                  'Description'.tr, transaction.description),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
