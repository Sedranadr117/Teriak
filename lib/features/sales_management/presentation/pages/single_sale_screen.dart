import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
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

  @override
  void initState() {
    super.initState();
    customerController = Get.put(CustomerController(), tag: widget.tabId);
    saleController =
        Get.put(SaleController(customerTag: widget.tabId), tag: widget.tabId);
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
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
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
                              final item = InvoiceItemModel(
                                id: stock.id,
                                productName: stock.productName,
                                unitPrice: stock.sellingPrice,
                                stockItemId: stock.id,
                                quantity: stock.totalQuantity,
                                subTotal: 0,
                              );
                              saleController.addItemFromProduct(item);
                            }
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
                    final item = InvoiceItemModel(
                      id: stock.id,
                      productName: stock.productName,
                      unitPrice: stock.sellingPrice,
                      stockItemId: stock.id,
                      quantity: stock.totalQuantity,
                      subTotal: 0,
                    );
                    saleController.addItemFromProduct(item);
                    saleController.searchController.text = item.productName;
                    saleController.results.clear();
                  },
                  hintText: 'Search by product name or generic name...'.tr,
                  isScanner: true,
                ),
              ),
              CustomerInformationCard(
                isLoading: customerController.isLoading,
                customers: customerController.customers,
                selectedCustomer: customerController.selectedCustomer,
                customerController: customerController,
              ),
              Obx(() => InvoiceItemsCard(
                    items: saleController.invoiceItems.toList(),
                    onQuantityChanged: saleController.updateItemQuantity,
                  )),
              SizedBox(height: 4.w),
              Obx(
                () => CurrencySelectionCardWidget(
                  selectedCurrency: saleController.selectedCurrency.value,
                  onCurrencyChanged: (currency) {
                    saleController.onCurrencyChanged(currency);
                  },
                ),
              ),
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
                  dueDate: saleController.startDate.value,
                  onPaymentTypeChanged: (type) {
                    setState(() {
                      saleController.selectedPaymentType.value = type;
                    });
                  },
                  onDueDateChanged: (date) {
                    setState(() {
                      saleController.endDate.value = date;
                    });
                  },
                ),
              ),
              // PaymentProcessingScreen(),
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
                    processPayment: () {
                      saleController.createSale(
                          saleController.invoiceItems
                              .map((e) => e.copyWith().toSaleItemParams())
                              .toList(),
                          customerController.selectedCustomer.value?.id);
                      if (saleController.done) {
                        _completeSale();
                      }
                    },
                    currencySymbol: saleController.getCurrencySymbol(
                        saleController.selectedCurrency.value),
                    totalAmount: saleController.total.value),
              )
            ],
          ),
        ),
      ),
    );
  }
}
