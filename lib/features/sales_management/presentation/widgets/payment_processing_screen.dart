import 'package:flutter/material.dart';

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

  // Cash payment
  // ignore: unused_field
  final double _cashReceived = 0.0;

  // Card payment
  // ignore: unused_field
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

  // ignore: unused_element
  double get _totalAmount => (_paymentData['totalAmount'] as double?) ?? 0.0;
  // ignore: unused_element
  String get _currency => _paymentData['currency'] ?? 'USD';

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

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          // Process Payment Button

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
