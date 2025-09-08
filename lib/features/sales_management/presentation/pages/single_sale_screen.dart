import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/features/money_box/presentation/controller/get_money_box_controlller.dart';
import 'package:teriak/features/sales_management/presentation/controllers/sale_controller.dart';
import 'package:teriak/features/sales_management/presentation/widgets/currency_selection_card_widget.dart';
import 'package:teriak/features/sales_management/presentation/widgets/customer_information_card.dart';
import 'package:teriak/features/sales_management/presentation/widgets/invoice_items_card.dart';
import 'package:teriak/features/sales_management/presentation/widgets/invoice_total_card.dart';
import 'package:teriak/features/sales_management/presentation/widgets/payment_button_widget.dart';
import 'package:teriak/features/sales_management/presentation/widgets/payment_configuration_card_widget.dart';
import 'package:teriak/features/sales_management/presentation/widgets/payment_method_selection_widget.dart';
import 'package:teriak/features/sales_management/presentation/widgets/search_bar_widget.dart';
import 'package:teriak/features/bottom_sheet_management/barcode_bottom_sheet.dart';
import 'package:teriak/features/customer_managment/presentation/controllers/customer_controller.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/stock_management/presentation/controller/stock_controller.dart';

class SingleSaleScreen extends StatefulWidget {
  final String tabId;
  final VoidCallback? onSaleCompleted;

  const SingleSaleScreen(
      {super.key, required this.tabId, this.onSaleCompleted});

  @override
  State<SingleSaleScreen> createState() => _SingleSaleScreenState();
}

class _SingleSaleScreenState extends State<SingleSaleScreen> {
  late SaleController saleController;
  late CustomerController customerController;
  late StockController stockcontroller;
  late final GetMoneyBoxController moneyBoxController;

  @override
  void initState() {
    super.initState();
    customerController = Get.put(CustomerController(), tag: widget.tabId);
    saleController =
        Get.put(SaleController(customerTag: widget.tabId), tag: widget.tabId);
    stockcontroller = Get.find<StockController>();
    moneyBoxController = Get.find<GetMoneyBoxController>();
    customerController.fetchCustomers();
  }

  @override
  void dispose() {
    Get.delete<SaleController>(tag: widget.tabId);
    Get.delete<CustomerController>(tag: widget.tabId);
    super.dispose();
  }

  void _completeSale() {
    if (widget.onSaleCompleted != null) {
      widget.onSaleCompleted!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => SearchBarWidget(
                controller: saleController.searchController,
                focusNode: saleController.searchFocusNode,
                onChanged: (value) {
                  saleController.search(value);
                },
                onBarcodeScanned: () {
                  showBarcodeScannerBottomSheet(
                    onScanned: (code) {
                      print("✅ الباركود هو: $code");
                      saleController.searchController.text = code;
                      saleController.search(code).then((_) {
                        if (saleController.results.isNotEmpty) {
                          for (var stock in saleController.results) {
                            final unitPrice =
                                saleController.selectedCurrency.value == 'USD'
                                    ? stock.sellingPriceUSD
                                    : stock.sellingPrice;
                            print(
                                '🔍 Barcode Debug: Currency=${saleController.selectedCurrency.value}, SYP=${stock.sellingPrice}, USD=${stock.sellingPriceUSD}, Selected=$unitPrice');
                            final item = InvoiceItemModel(
                              id: stock.id,
                              productName: stock.productName,
                              unitPrice: unitPrice,
                              stockItemId: stock.id,
                              quantity: stock.totalQuantity,
                              subTotal: 0,
                              refundedQuantity: 0,
                              availableForRefund: stock.totalQuantity,
                            );
                            saleController.addItemFromProduct(item);
                          }
                          saleController.searchFocusNode.unfocus();
                          saleController.searchController.clear();
                          saleController.results.clear();
                          setState(() {});
                        }
                      });
                    },
                  );
                },
                results: saleController.results,
                isSearching: saleController.isSearching.value,
                itemBuilder: (product) => ListTile(
                  title: Text(product.productName),
                ),
                onItemTap: (stock) {
                  final unitPrice =
                      saleController.selectedCurrency.value == 'USD'
                          ? stock.sellingPriceUSD
                          : stock.sellingPrice;
                  print(
                      '🔍 Manual Debug: Currency=${saleController.selectedCurrency.value}, SYP=${stock.sellingPrice}, USD=${stock.sellingPriceUSD}, Selected=$unitPrice');
                  final item = InvoiceItemModel(
                    id: stock.id,
                    productName: stock.productName,
                    unitPrice: unitPrice,
                    stockItemId: stock.id,
                    quantity: stock.totalQuantity,
                    subTotal: 0,
                    refundedQuantity: 0,
                    availableForRefund: stock.totalQuantity,
                  );
                  saleController.addItemFromProduct(item);
                  saleController.searchController.clear();
                  saleController.results.clear();
                  saleController.searchFocusNode.unfocus();
                  setState(() {});
                },
                hintText: 'Search by product name or generic name...'.tr,
                isScanner: true,
              ),
            ),
            Obx(
              () => CurrencySelectionCardWidget(
                selectedCurrency: saleController.selectedCurrency.value,
                onCurrencyChanged: (currency) {
                  print('🎯 SingleSaleScreen: Currency changed to $currency');
                  saleController.onCurrencyChanged(currency);
                },
              ),
            ),
            Obx(() => InvoiceItemsCard(
                  items: saleController.invoiceItems.toList(),
                  onQuantityChanged: saleController.updateItemQuantity,
                  selectedCurrency: saleController.selectedCurrency.value,
                )),
            Obx(
              () => InvoiceTotalCard(
                subtotal: saleController.subtotal.value,
                discountAmount: saleController.discountAmount.value,
                total: saleController.total.value,
                discountController: saleController.discountController,
                discountType: saleController.discountType.value,
                onDiscountTypeChanged: (type) {
                  setState(() {
                    saleController.discountType.value = type;
                  });
                  saleController.calculateTotals();
                },
                onApplyDiscount: saleController.applyDiscount,
                selectedCurrency: saleController.selectedCurrency.value,
              ),
            ),
            Obx(
              () => PaymentConfigurationCardWidget(
                paymentType: saleController.selectedPaymentType.value,
                dueDate: saleController.dueDateController.text.isNotEmpty
                    ? (DateTime.tryParse(
                            saleController.dueDateController.text) ??
                        DateTime.now())
                    : DateTime.now(),
                onPaymentTypeChanged: (type) {
                  saleController.selectedPaymentType.value = type;
                },
                controller: saleController.deferredAmountController,
                onDateTap: () async {
                  await saleController.selectDueDate(
                      initialDate:
                          saleController.dueDateController.text.isNotEmpty
                              ? DateTime.parse(
                                  saleController.dueDateController.text)
                              : DateTime.now(),
                      context: context);
                  setState(() {});
                },
              ),
            ),
            Obx(() => saleController.selectedPaymentType.value == 'CREDIT'
                ? CustomerInformationCard(
                    isLoading: customerController.isLoading,
                    customers: customerController.customers,
                    selectedCustomer: customerController.selectedCustomer,
                    customerController: customerController,
                    onRefresh: () {
                      customerController.fetchCustomers();
                    },
                  )
                : SizedBox()),
            Obx(
              () => PaymentMethodSelectionWidget(
                selectedMethod: saleController.selectedPaymentMethod.value,
                onMethodSelected: (method) {
                  saleController.onPaymentMethodSelected(method);
                },
              ),
            ),
            Obx(
              () => PaymentButton(
                  isLoading: saleController.isLoading.value,
                  processPayment: () async {
                    saleController.createSale(
                        saleController.invoiceItems
                            .map((e) => e.copyWith().toSaleItemParams())
                            .toList(),
                        customerController.selectedCustomer.value?.id);
                    if (saleController.done) {
                      _completeSale();
                      await stockcontroller.fetchStock();
                      moneyBoxController.refreshData();
                      setState(() {});
                    }
                  },
                  currencySymbol: saleController
                      .getCurrencySymbol(saleController.selectedCurrency.value),
                  totalAmount:
                      saleController.selectedPaymentType.value == "CREDIT"
                          ? saleController.defferredAmount.value
                          : saleController.total.value,
                  isPaymentTypeSelected:
                      saleController.selectedPaymentType.value.isNotEmpty,
                  isCustomerSelected:
                      customerController.selectedCustomer.value != null,
                  paymentType: saleController.selectedPaymentType.value),
            )
          ],
        ),
      ),
    );
  }
}
