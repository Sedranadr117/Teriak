import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/widgets/payment_method_selection_widget.dart';

class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key});

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController _confirmationController;

  // Payment data from previous screen
  Map<String, dynamic> _paymentData = {};

  // Current state
  String _selectedPaymentMethod = 'Cash';
  bool _isProcessing = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _transactionId = '';

  // Cash payment
  final double _cashReceived = 0.0;

  // Card payment
  final bool _isCardConnected = false;
  // ignore: unused_field
  final String _cardStatus = 'Insert or tap card';

  @override
  void initState() {
    super.initState();
    _confirmationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Get payment data from arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _paymentData = args;
        });
      }
    });
  }

  double get _totalAmount => (_paymentData['totalAmount'] as double?) ?? 0.0;
  String get _currency => _paymentData['currency'] ?? 'USD';
  List<Map<String, dynamic>> get _invoiceItems =>
      List<Map<String, dynamic>>.from(_paymentData['invoiceItems'] ?? []);

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'SYP':
        return 'SYP';
      default:
        return 'SYP';
    }
  }

  void _onPaymentMethodSelected(String method) {
    setState(() {
      _selectedPaymentMethod = method;
      _hasError = false;
      _errorMessage = '';
    });
  }

  // void _onCashAmountChanged(double amount) {
  //   setState(() {
  //     _cashReceived = amount;
  //     _changeAmount = amount - _totalAmount;
  //   });
  // }

  // void _onCardStatusChanged(String status, bool isConnected) {
  //   setState(() {
  //     _cardStatus = status;
  //     _isCardConnected = isConnected;
  //   });
  // }

  Future<void> _processPayment() async {
    if (_selectedPaymentMethod.isEmpty) {
      _showError('Please select a payment method');
      return;
    }

    // Validate payment method specific requirements
    if (_selectedPaymentMethod == 'Cash' && _cashReceived < _totalAmount) {
      _showError('Insufficient cash amount');
      return;
    }

    if ((_selectedPaymentMethod == 'Credit Card' ||
            _selectedPaymentMethod == 'Debit Card') &&
        !_isCardConnected) {
      _showError('Please insert or tap your card');
      return;
    }

    setState(() {
      _isProcessing = true;
      _hasError = false;
    });

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      // Simulate random success/failure for demo
      final success = DateTime.now().millisecond % 10 != 0; // 90% success rate

      if (success) {
        setState(() {
          _isProcessing = false;
          _transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
        });

        // Trigger success animation and haptic feedback
        _confirmationController.forward();
        HapticFeedback.lightImpact();

        // Add to sales history (simulate)
        _addToSalesHistory();
      } else {
        throw Exception('Payment declined');
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _hasError = true;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _showError(String message) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _addToSalesHistory() {
    final saleRecord = {
      'transactionId': _transactionId,
      'date': DateTime.now().toIso8601String(),
      'items': _invoiceItems,
      'totalAmount': _totalAmount,
      'currency': _currency,
      'paymentMethod': _selectedPaymentMethod,
      'customerName': _paymentData['customerName'] ?? 'Walk-in Customer',
      'customerPhone': _paymentData['customerPhone'] ?? '',
      'status': 'Completed',
    };

    // TODO: Save to actual storage/database
    print('Sale added to history: $saleRecord');
  }

  void _retryPayment() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildPaymentScreen()],
    );
  }

  Widget _buildPaymentScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Payment Method Selection
          PaymentMethodSelectionWidget(
            selectedMethod: _selectedPaymentMethod,
            onMethodSelected: _onPaymentMethodSelected,
          ),
          const SizedBox(height: 16),

          // Payment Method Specific Widgets
          if (_selectedPaymentMethod == 'Cash')
            // CashPaymentWidget(
            //   totalAmount: _totalAmount,
            //   currencySymbol: _getCurrencySymbol(_currency),
            //   cashReceived: _cashReceived,
            //   changeAmount: _changeAmount,
            //   onCashAmountChanged: _onCashAmountChanged,
            // ),

            if (_selectedPaymentMethod == 'Credit Card')
              // CardPaymentWidget(
              //   paymentMethod: _selectedPaymentMethod,
              //   totalAmount: _totalAmount,
              //   currencySymbol: _getCurrencySymbol(_currency),
              //   isConnected: _isCardConnected,
              //   status: _cardStatus,
              //   onStatusChanged: _onCardStatusChanged,
              // ),

              const SizedBox(height: 16),

          // Error Display
          if (_hasError)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Failed',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[700],
                                  ),
                        ),
                        Text(
                          _errorMessage,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.red[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _retryPayment,
                    child: Text(
                      'Retry',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.red[700],
                          ),
                    ),
                  ),
                ],
              ),
            ),

          // Process Payment Button
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Processing Payment...'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.backgroundColor),
                          ),
                        ],
                      )
                    : Text(
                        '${'Process Payment'.tr} ${_getCurrencySymbol(_currency)}${_totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.backgroundColor),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
