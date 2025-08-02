import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_assets.dart';
import 'package:teriak/config/themes/app_icon.dart';

class PaymentBottomSheet extends StatefulWidget {
  final Map<String, dynamic> customer;
  final Function(Map<String, dynamic>) onPaymentSubmitted;

  const PaymentBottomSheet({
    super.key,
    required this.customer,
    required this.onPaymentSubmitted,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _paymentMethod = 'Cash';
  bool _isSubmitting = false;

  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Check',
    'Bank Transfer',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill with total debt amount
    final totalDebt = (widget.customer['totalDebt'] as num?)?.toDouble() ?? 0.0;
    _amountController.text = totalDebt.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalDebt = (widget.customer['totalDebt'] as num?)?.toDouble() ?? 0.0;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Payment',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer info
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color:
                                    colorScheme.outline.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: widget.customer['profileImage'] != null
                                  ? Image.asset(Assets.assetsImagesJustLogo)
                                  : Center(
                                      child: CustomIconWidget(
                                        iconName: 'person',
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.4),
                                        size: 6.w,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.customer['name']?.toString() ??
                                      'Unknown Customer',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Total Debt: \$${totalDebt.toStringAsFixed(2)}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Payment amount
                    Text(
                      'Payment Amount',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$',
                        hintText: '0.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                        if (amount > totalDebt) {
                          return 'Payment cannot exceed total debt';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 2.h),

                    // Quick amount buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _amountController.text =
                                  (totalDebt * 0.25).toStringAsFixed(2);
                            },
                            child: Text('25%'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _amountController.text =
                                  (totalDebt * 0.5).toStringAsFixed(2);
                            },
                            child: Text('50%'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _amountController.text =
                                  (totalDebt * 0.75).toStringAsFixed(2);
                            },
                            child: Text('75%'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _amountController.text =
                                  totalDebt.toStringAsFixed(2);
                            },
                            child: Text('Full'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Payment method
                    Text(
                      'Payment Method',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      value: _paymentMethod,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: _paymentMethods.map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value ?? 'Cash';
                        });
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Notes
                    Text(
                      'Notes (Optional)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        labelText: 'Payment notes',
                        hintText: 'Add any notes about this payment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitPayment,
                    child: _isSubmitting
                        ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text('Record Payment'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1000));

    final amount = double.parse(_amountController.text);

    final paymentData = {
      'customerId': widget.customer['id'],
      'amount': amount,
      'paymentMethod': _paymentMethod,
      'notes': _notesController.text,
      'date': DateTime.now().toIso8601String(),
    };

    widget.onPaymentSubmitted(paymentData);
    Navigator.pop(context);

    setState(() {
      _isSubmitting = false;
    });
  }
}
