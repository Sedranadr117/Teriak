import 'package:flutter/material.dart';

class CardPaymentWidget extends StatefulWidget {
  final String paymentMethod;
  final double totalAmount;
  final String currencySymbol;
  final bool isConnected;
  final String status;
  final Function(String, bool) onStatusChanged;

  const CardPaymentWidget({
    super.key,
    required this.paymentMethod,
    required this.totalAmount,
    required this.currencySymbol,
    required this.isConnected,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  State<CardPaymentWidget> createState() => _CardPaymentWidgetState();
}

class _CardPaymentWidgetState extends State<CardPaymentWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  void _simulateCardInsert() {
    setState(() {
      _isProcessing = true;
    });

    widget.onStatusChanged('Reading card...', false);
    _progressController.forward();

    Future.delayed(const Duration(seconds: 1), () {
      widget.onStatusChanged('Please wait...', false);
    });

    Future.delayed(const Duration(seconds: 2), () {
      widget.onStatusChanged('Card detected', true);
      setState(() {
        _isProcessing = false;
      });
      _progressController.reset();
    });
  }

  void _simulateCardTap() {
    setState(() {
      _isProcessing = true;
    });

    widget.onStatusChanged('Processing tap...', false);
    _progressController.forward();

    Future.delayed(const Duration(seconds: 1), () {
      widget.onStatusChanged('Card detected', true);
      setState(() {
        _isProcessing = false;
      });
      _progressController.reset();
    });
  }

  void _removeCard() {
    widget.onStatusChanged('Insert or tap card', false);
  }

  Color _getStatusColor() {
    if (widget.isConnected) return Colors.green;
    if (_isProcessing) return Colors.orange;
    return Colors.grey;
  }

  IconData _getStatusIcon() {
    if (widget.isConnected) return Icons.check_circle;
    if (_isProcessing) return Icons.sync;
    return Icons.credit_card;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

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
                    color: Colors.blue.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.paymentMethod == 'Credit Card'
                        ? Icons.credit_card
                        : Icons.payment,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.paymentMethod} Payment',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Amount: ${widget.currencySymbol}${widget.totalAmount.toStringAsFixed(2)}',
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

            // Card reader status
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withAlpha(77)),
              ),
              child: Column(
                children: [
                  Icon(
                    _getStatusIcon(),
                    color: statusColor,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Card Reader',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.status,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (_isProcessing) ...[
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: statusColor.withAlpha(51),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(statusColor),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Connection status
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isConnected
                      ? 'Card reader connected'
                      : _isProcessing
                          ? 'Processing...'
                          : 'Waiting for card',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Action buttons
            if (!widget.isConnected && !_isProcessing) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _simulateCardInsert,
                      icon: const Icon(Icons.input, size: 18),
                      label: Text(
                        'Simulate Insert',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.blue[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _simulateCardTap,
                      icon: const Icon(Icons.tap_and_play, size: 18),
                      label: Text(
                        'Simulate Tap',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.blue[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            if (widget.isConnected) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card Ready for Processing',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Transaction will be processed when you click "Process Payment"',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.green[600],
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _removeCard,
                      child: Text(
                        'Remove',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[700],
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Security info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All card transactions are encrypted and PCI DSS compliant',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }
}
