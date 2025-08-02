import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/widgets/currency_selection_card_widget.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/widgets/customer_information_card.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/widgets/invoice_items_card.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/widgets/invoice_total_card.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/widgets/payment_configuration_card_widget.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/widgets/payment_processing_screen.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/widgets/search_bar_widget.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _searchHistory = [];
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  // Controllers for discount
  final TextEditingController _discountController = TextEditingController();

  // Invoice state
  List<InvoiceItem> _invoiceItems = [];
  double _subtotal = 0.0;
  double _discountAmount = 0.0;
  double _taxAmount = 0.0;
  double _total = 0.0;

  String _discountType = 'percentage';
  String _selectedPaymentType = 'Cash'.tr;
  DateTime? _selectedDueDate;
  void _addSampleItems() {
    setState(() {
      _invoiceItems = [
        InvoiceItem(
          id: '1',
          name: 'Amoxicillin 500mg',
          quantity: 2,
          unitPrice: 15.99,
          isPrescription: true,
        ),
        InvoiceItem(
          id: '2',
          name: 'Tylenol Extra Strength',
          quantity: 1,
          unitPrice: 8.49,
          isPrescription: false,
        ),
        InvoiceItem(
          id: '3',
          name: 'Vitamin D3 1000 IU',
          quantity: 1,
          unitPrice: 12.99,
          isPrescription: false,
        ),
      ];
    });
    _calculateTotals();
  }

  void _calculateTotals() {
    _subtotal = _invoiceItems.fold(0.0, (sum, item) => sum + item.total);

    if (_discountType == 'percentage') {
      _discountAmount =
          _subtotal * (double.tryParse(_discountController.text) ?? 0.0) / 100;
    } else {
      _discountAmount = double.tryParse(_discountController.text) ?? 0.0;
    }

    double discountedSubtotal = _subtotal - _discountAmount;

    _total = discountedSubtotal + _taxAmount;

    setState(() {});
  }

  void _updateItemQuantity(String itemId, int newQuantity) {
    setState(() {
      final itemIndex = _invoiceItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        if (newQuantity <= 0) {
          _invoiceItems.removeAt(itemIndex);
        } else {
          _invoiceItems[itemIndex] =
              _invoiceItems[itemIndex].copyWith(quantity: newQuantity);
        }
      }
    });
    _calculateTotals();
  }

  void _applyDiscount() {
    _calculateTotals();
    // Fluttertoast.showToast(
    //   msg: 'Discount applied successfully',
    //   backgroundColor: AppTheme.successLight,
    //   textColor: Colors.white,
    // );
  }

  void _onCurrencyChanged(String currency) {
    setState(() {
      _selectedCurrency = currency;
    });
  }

  String _selectedCurrency = 'SYP';

  @override
  void initState() {
    super.initState();
    _addSampleItems();

    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    // Load search history from SharedPreferences
    setState(() {
      _searchHistory = ['Acetaminophen', 'Ibuprofen', 'Amoxicillin'];
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {});
      return;
    }

    setState(() {});

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {});

      // Add to search history
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.take(10).toList();
        }
      }
    });
  }

  void _onBarcodeScanned(String barcode) {
    _searchController.text = barcode;
    _performSearch(barcode);
  }

  void onPaymentTypeChanged(String type) {
    setState(() {
      _selectedCurrency = type;
    });
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
              SearchBarWidget(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _performSearch,
                onBarcodeScanned: _onBarcodeScanned,
                searchHistory: _searchHistory,
              ),
              CustomerInformationCard(
                customerNameController: firstNameController,
              ),

              InvoiceItemsCard(
                items: _invoiceItems,
                onQuantityChanged: _updateItemQuantity,
              ),

              SizedBox(height: 4.w),
              CurrencySelectionCardWidget(
                selectedCurrency: _selectedCurrency,
                onCurrencyChanged: (String) {
                  _onCurrencyChanged(_selectedCurrency);
                },
              ),
              // Invoice Total with Discount
              InvoiceTotalCard(
                subtotal: _subtotal,
                discountAmount: _discountAmount,
                total: _total,
                discountController: _discountController,
                discountType: _discountType,
                onDiscountTypeChanged: (type) {
                  setState(() {
                    _discountType = type;
                  });
                  _calculateTotals();
                },
                onApplyDiscount: _applyDiscount,
              ),
              PaymentConfigurationCardWidget(
                paymentType: _selectedPaymentType,
                dueDate: _selectedDueDate,
                onPaymentTypeChanged: (type) {
                  setState(() {
                    _selectedPaymentType = type;
                  });
                },
                onDueDateChanged: (date) {
                  setState(() {
                    _selectedDueDate = date;
                  });
                },
              ),
              PaymentProcessingScreen(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
