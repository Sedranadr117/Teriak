import 'package:flutter/material.dart';

class CashPaymentWidget extends StatefulWidget {
  final double totalAmount;
  final String currencySymbol;
  final double cashReceived;
  final double changeAmount;
  final Function(double) onCashAmountChanged;

  const CashPaymentWidget({
    super.key,
    required this.totalAmount,
    required this.currencySymbol,
    required this.cashReceived,
    required this.changeAmount,
    required this.onCashAmountChanged,
  });

  @override
  State<CashPaymentWidget> createState() => _CashPaymentWidgetState();
}

class _CashPaymentWidgetState extends State<CashPaymentWidget> {
  final TextEditingController _amountController = TextEditingController();

  final List<double> _quickAmounts = [1, 5, 10, 20, 50, 100];

  @override
  void initState() {
    super.initState();
    _amountController.text =
        widget.cashReceived > 0 ? widget.cashReceived.toStringAsFixed(2) : '';
  }

  void _addQuickAmount(double amount) {
    final currentAmount = double.tryParse(_amountController.text) ?? 0;
    final newAmount = currentAmount + amount;
    _amountController.text = newAmount.toStringAsFixed(2);
    widget.onCashAmountChanged(newAmount);
  }

  void _setExactAmount() {
    _amountController.text = widget.totalAmount.toStringAsFixed(2);
    widget.onCashAmountChanged(widget.totalAmount);
  }

  void _clearAmount() {
    _amountController.clear();
    widget.onCashAmountChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.money,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cash Payment',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ${widget.currencySymbol}${widget.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Cash amount input
            TextFormField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Cash Received',
                hintText: '0.00',
                prefixText: widget.currencySymbol,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: _clearAmount,
                      tooltip: 'Clear',
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle, size: 20),
                      onPressed: _setExactAmount,
                      tooltip: 'Exact amount',
                    ),
                  ],
                ),
              ),
              onChanged: (value) {
                final amount = double.tryParse(value) ?? 0;
                widget.onCashAmountChanged(amount);
              },
            ),
            const SizedBox(height: 16),

            // Quick denomination buttons
            Text(
              'Quick Denominations',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickAmounts.map((amount) {
                return OutlinedButton(
                  onPressed: () => _addQuickAmount(amount),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    side: BorderSide(color: Colors.green[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    '${widget.currencySymbol}${amount.toInt()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Change calculation
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.changeAmount >= 0
                    ? Colors.green[50]
                    : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.changeAmount >= 0
                      ? Colors.green[200]!
                      : Colors.red[200]!,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount Due:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                      ),
                      Text(
                        '${widget.currencySymbol}${widget.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cash Received:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                      ),
                      Text(
                        '${widget.currencySymbol}${widget.cashReceived.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.changeAmount >= 0 ? 'Change:' : 'Remaining:',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: widget.changeAmount >= 0
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                ),
                      ),
                      Text(
                        '${widget.currencySymbol}${widget.changeAmount.abs().toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: widget.changeAmount >= 0
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (widget.changeAmount < 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Insufficient cash amount. Please add more cash to proceed.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
