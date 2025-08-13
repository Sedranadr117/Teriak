import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewPaymentBottomSheet extends StatefulWidget {
  final Map<String, dynamic> customerData;
  final Function(Map<String, dynamic>) onPaymentAdded;

  const NewPaymentBottomSheet({
    Key? key,
    required this.customerData,
    required this.onPaymentAdded,
  }) : super(key: key);

  @override
  State<NewPaymentBottomSheet> createState() => _NewPaymentBottomSheetState();
}

class _NewPaymentBottomSheetState extends State<NewPaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPaymentMethod = 'Cash';
  DateTime _selectedDate = DateTime.now();
  bool _generateReceipt = true;
  bool _isProcessing = false;

  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Check',
    'Digital Wallet',
  ];

  @override
  void initState() {
    super.initState();
    _generateReferenceNumber();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _generateReferenceNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _referenceController.text = 'PAY-${timestamp.toString().substring(8)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(
                        Icons.payment,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Record New Payment',
                              style: theme.textTheme.headlineSmall,
                            ),
                            Text(
                              'For ${widget.customerData['name']}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Outstanding Balance Info
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error.withAlpha(77),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Outstanding Balance',
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                '\$${widget.customerData['remainingBalance'].toStringAsFixed(2)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Payment Amount
                  Text(
                    'Payment Amount',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      hintText: '0.00',
                      suffixIcon: TextButton(
                        onPressed: () {
                          _amountController.text = widget
                              .customerData['remainingBalance']
                              .toStringAsFixed(2);
                        },
                        child: Text('Full Amount'),
                      ),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter payment amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Payment Method
                  Text(
                    'Payment Method',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      prefixIcon:
                          Icon(_getPaymentMethodIcon(_selectedPaymentMethod)),
                    ),
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Row(
                          children: [
                            Icon(_getPaymentMethodIcon(method), size: 20),
                            SizedBox(width: 12),
                            Text(method),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),

                  SizedBox(height: 20),

                  // Payment Date
                  Text(
                    'Payment Date',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Reference Number
                  Text(
                    'Reference Number',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _referenceController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.confirmation_number),
                      suffixIcon: IconButton(
                        onPressed: _generateReferenceNumber,
                        icon: Icon(Icons.refresh),
                        tooltip: 'Generate New Reference',
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter reference number';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Payment Notes (Optional)
                  Text(
                    'Payment Notes (Optional)',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      hintText:
                          'Add any additional notes about this payment...',
                      prefixIcon: Icon(Icons.note_alt),
                    ),
                    maxLines: 3,
                    minLines: 2,
                  ),

                  SizedBox(height: 20),

                  // Options
                  CheckboxListTile(
                    title: Text('Generate Receipt'),
                    subtitle: Text('Create a digital receipt for this payment'),
                    value: _generateReceipt,
                    onChanged: (value) {
                      setState(() {
                        _generateReceipt = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isProcessing
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isProcessing ? null : _processPayment,
                          child: _isProcessing
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text('Record Payment'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2));

    final paymentData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'date':
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
      'amount': double.parse(_amountController.text),
      'method': _selectedPaymentMethod,
      'status': 'Completed',
      'reference': _referenceController.text,
      'receipt': _generateReceipt,
      'notes': _notesController.text.isEmpty ? null : _notesController.text,
    };

    widget.onPaymentAdded(paymentData);

    setState(() {
      _isProcessing = false;
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment recorded successfully'),
        action: _generateReceipt
            ? SnackBarAction(
                label: 'View Receipt',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Receipt generated and saved')),
                  );
                },
              )
            : null,
      ),
    );
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'Cash':
        return Icons.money;
      case 'Credit Card':
        return Icons.credit_card;
      case 'Debit Card':
        return Icons.payment;
      case 'Bank Transfer':
        return Icons.account_balance;
      case 'Check':
        return Icons.receipt_long;
      case 'Digital Wallet':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }
}
