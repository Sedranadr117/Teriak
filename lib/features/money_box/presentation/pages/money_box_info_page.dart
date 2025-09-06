import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
    final isRtl = Get.locale?.languageCode == 'ar';
    final fabLocation = isRtl
        ? FloatingActionButtonLocation.startFloat
        : FloatingActionButtonLocation.endFloat;
    return Scaffold(
      floatingActionButtonLocation: fabLocation,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            moneyBoxController.refreshData(),
            transactionsController.refreshData(),
          ]);
        },
        child: Column(
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
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
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
                  transactionsController.transactions.value!.totalElements >
                      0) {
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
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).colorScheme.primary,
        overlayOpacity: 0.5,
        spacing: 10,
        spaceBetweenChildren: 10,
        direction: SpeedDialDirection.up,
        switchLabelPosition: false,
        children: [
          SpeedDialChild(
            child: Icon(Icons.swap_vert, color: Colors.white),
            backgroundColor: AppColors.appColor4,
            onTap: () {
              Get.dialog(AddTransactionDialog());
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.balance, color: Colors.white),
            backgroundColor: AppColors.primaryVariantLight,
            onTap: () {
              Get.dialog(AddReconcileDialog());
            },
          ),
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
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Text(
                'Money Box Information'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(),
              ),
              SizedBox(height: 1.h),
              _buildInfoRow('Status'.tr, moneyBox.status),
              _buildInfoRow(
                  'Last Reconciled'.tr, moneyBox.formattedCreationDateTime),
              _buildInfoRow('current USD To SYP Rate'.tr,
                  moneyBox.currentUSDToSYPRate.toString()),
              _buildInfoRow('Total Balance (SYP)'.tr,
                  '${moneyBox.totalBalanceInSYP.toString()} SYP'),
              _buildInfoRow('Total Balance (USD)'.tr,
                  '${moneyBox.totalBalanceInUSD.toString()} USD'),
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
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    Widget _buildDateField(
      BuildContext context,
      String label,
      DateTime? selectedDate,
      Function(DateTime) onDateSelected,
      String? errorText,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 0.5.h),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                onDateSelected(date);
                setState(() {});
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: errorText != null
                      ? Colors.red
                      : Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}'
                        : 'Select Date'.tr,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: selectedDate != null
                          ? Theme.of(context).textTheme.bodyMedium?.color
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.8),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 11.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget _buildTypeField(
      BuildContext context,
      String label,
      String? selectedType,
      Function(String) onTypeSelected,
    ) {
      const List<String> types = [
        "OPENING_BALANCE",
        "CASH_DEPOSIT",
        "CASH_WITHDRAWAL",
        "SALE_PAYMENT",
        "SALE_REFUND",
        "PURCHASE_REFUND",
        "PURCHASE_PAYMENT",
        "INCOME",
        "ADJUSTMENT",
        "CLOSING_BALANCE",
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 0.5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedType?.isNotEmpty == true ? selectedType : null,
                hint: Text('Select Type'.tr),
                isExpanded: true,
                items: types.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onTypeSelected(value);
                  }
                },
              ),
            ),
          ),
        ],
      );
    }

    void showFilterDialog() {
      Get.bottomSheet(
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => _buildDateField(
                      context,
                      'Start Date'.tr,
                      transactionsController.startDateFilter.value,
                      (date) =>
                          transactionsController.startDateFilter.value = date,
                      null,
                    )),
                SizedBox(height: 1.h),
                Obx(() => _buildDateField(
                      context,
                      'End Date'.tr,
                      transactionsController.endDateFilter.value,
                      (date) =>
                          transactionsController.endDateFilter.value = date,
                      null,
                    )),
                SizedBox(height: 1.h),
                // Obx(() => _buildTypeField(
                //       context,
                //       'Transaction Type'.tr,
                //       transactionsController.transactionTypeFilter.value,
                //       (type) => transactionsController.setTransactionType(type),
                //     )),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: () {
                    transactionsController.getTransactionsData();
                   
                  },
                  child: Text('Apply Filters'.tr),
                )
              ],
            ),
          ),
        ),
      );
    }

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
              Center(
                  child: CommonWidgets.buildErrorWidget(
                context: context,
                errorMessage: "",
                onPressed: transactionsController.refreshData,
              ))
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
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Money Box Transactions'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.filter_list,color:Theme.of(context).colorScheme.primary ,),
                  onPressed: () => showFilterDialog(),
                )
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
                  '${transaction.amount.toString()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            transaction.amount >= 0 ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            _buildTransactionInfoRow(
                'Balance Before'.tr, '${transaction.balanceBefore.toString()}'),
            _buildTransactionInfoRow(
                'Balance After'.tr, '${transaction.balanceAfter.toString()}'),
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
