import 'package:flutter/material.dart';

class PaymentHistorySection extends StatelessWidget {
  final List<Map<String, dynamic>> paymentHistory;

  const PaymentHistorySection({
    Key? key,
    required this.paymentHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment History',
          style: theme.textTheme.headlineSmall,
        ),
        SizedBox(height: 16),
        if (paymentHistory.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No payment history available',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: paymentHistory.length,
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemBuilder: (context, index) {
              final payment = paymentHistory[index];
              return _PaymentHistoryItem(
                payment: payment,
                onEdit: () => _showEditPaymentDialog(context, payment),
                onDelete: () => _showDeletePaymentDialog(context, payment),
                onViewReceipt: payment['receipt'] == true
                    ? () => _showReceiptDialog(context, payment)
                    : null,
              );
            },
          ),
      ],
    );
  }

  void _showEditPaymentDialog(
      BuildContext context, Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Payment'),
        content: Text('Manager authorization required to edit payments.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Payment edit requires manager approval')),
              );
            },
            child: Text('Request Authorization'),
          ),
        ],
      ),
    );
  }

  void _showDeletePaymentDialog(
      BuildContext context, Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Payment'),
        content: Text('Manager authorization required to delete payments.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Payment deletion requires manager approval')),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: Text('Request Authorization'),
          ),
        ],
      ),
    );
  }

  void _showReceiptDialog(BuildContext context, Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Receipt'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reference: ${payment['reference']}'),
            Text('Date: ${payment['date']}'),
            Text('Amount: \$${payment['amount'].toStringAsFixed(2)}'),
            Text('Method: ${payment['method']}'),
            Text('Status: ${payment['status']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Receipt downloaded')),
              );
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }
}

class _PaymentHistoryItem extends StatelessWidget {
  final Map<String, dynamic> payment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onViewReceipt;

  const _PaymentHistoryItem({
    Key? key,
    required this.payment,
    required this.onEdit,
    required this.onDelete,
    this.onViewReceipt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasReceipt = payment['receipt'] == true;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () => _showPaymentOptions(context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    _getPaymentMethodColor(payment['method']).withAlpha(26),
                child: Icon(
                  _getPaymentMethodIcon(payment['method']),
                  color: _getPaymentMethodColor(payment['method']),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${payment['amount'].toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(payment['status'])
                                .withAlpha(26),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            payment['status'] ?? 'Unknown',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(payment['status']),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      payment['method'] ?? 'Unknown method',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      payment['date'] ?? 'Unknown date',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (payment['reference'] != null)
                      Text(
                        'Ref: ${payment['reference']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (hasReceipt)
                IconButton(
                  onPressed: onViewReceipt,
                  icon: Icon(Icons.receipt),
                  tooltip: 'View Receipt',
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Payment'),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete,
                  color: Theme.of(context).colorScheme.error),
              title: Text('Delete Payment'),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
            if (onViewReceipt != null)
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text('View Receipt'),
                onTap: () {
                  Navigator.pop(context);
                  onViewReceipt!();
                },
              ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(String? method) {
    switch (method?.toLowerCase()) {
      case 'credit card':
        return Icons.credit_card;
      case 'cash':
        return Icons.money;
      case 'bank transfer':
        return Icons.account_balance;
      case 'check':
        return Icons.receipt_long;
      default:
        return Icons.payment;
    }
  }

  Color _getPaymentMethodColor(String? method) {
    switch (method?.toLowerCase()) {
      case 'credit card':
        return Colors.blue;
      case 'cash':
        return Colors.green;
      case 'bank transfer':
        return Colors.purple;
      case 'check':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
