import 'package:flutter/material.dart';

class DebtBreakdownSection extends StatefulWidget {
  final Map<String, dynamic> debtBreakdown;

  const DebtBreakdownSection({
    super.key,
    required this.debtBreakdown,
  });

  @override
  State<DebtBreakdownSection> createState() => _DebtBreakdownSectionState();
}

class _DebtBreakdownSectionState extends State<DebtBreakdownSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final breakdown = widget.debtBreakdown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Debt Breakdown',
          style: theme.textTheme.headlineSmall,
        ),
        SizedBox(height: 16),

        Card(
          child: Column(
            children: [
              // Summary
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildBreakdownRow(
                      'Original Amount',
                      breakdown['originalAmount'] ?? 0.0,
                      theme,
                    ),
                    SizedBox(height: 8),
                    _buildBreakdownRow(
                      'Interest Charges',
                      breakdown['interestCharges'] ?? 0.0,
                      theme,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 8),
                    _buildBreakdownRow(
                      'Late Fees',
                      breakdown['lateFees'] ?? 0.0,
                      theme,
                      color: Colors.red,
                    ),
                    SizedBox(height: 8),
                    _buildBreakdownRow(
                      'Adjustments',
                      breakdown['adjustments'] ?? 0.0,
                      theme,
                      color: Colors.green,
                      isNegative: true,
                    ),
                    Divider(),
                    _buildBreakdownRow(
                      'Total Amount',
                      _calculateTotal(breakdown),
                      theme,
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              // Expandable Details
              InkWell(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        theme.colorScheme.surfaceContainerHighest.withAlpha(77),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isExpanded ? 'Hide Details' : 'View Detailed Breakdown',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Detailed breakdown
        if (isExpanded) ...[
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction History',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (breakdown['details'] != null)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (breakdown['details'] as List).length,
                      separatorBuilder: (context, index) => Divider(height: 24),
                      itemBuilder: (context, index) {
                        final detail = breakdown['details'][index];
                        return _DebtDetailItem(detail: detail);
                      },
                    )
                  else
                    Center(
                      child: Text(
                        'No detailed breakdown available',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBreakdownRow(
    String label,
    double amount,
    ThemeData theme, {
    Color? color,
    bool isNegative = false,
    bool isTotal = false,
  }) {
    // ignore: unused_local_variable
    final displayAmount = isNegative ? -amount : amount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)
              : theme.textTheme.bodyLarge,
        ),
        Text(
          '${isNegative ? '-' : ''}\$${amount.toStringAsFixed(2)}',
          style: (isTotal
                  ? theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)
                  : theme.textTheme.bodyLarge)
              ?.copyWith(
            color: color ?? (isTotal ? theme.colorScheme.error : null),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  double _calculateTotal(Map<String, dynamic> breakdown) {
    final original = breakdown['originalAmount'] ?? 0.0;
    final interest = breakdown['interestCharges'] ?? 0.0;
    final fees = breakdown['lateFees'] ?? 0.0;
    final adjustments = breakdown['adjustments'] ?? 0.0;

    return original + interest + fees - adjustments;
  }
}

class _DebtDetailItem extends StatelessWidget {
  final Map<String, dynamic> detail;

  const _DebtDetailItem({
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = detail['type'] ?? 'Unknown';
    final amount = detail['amount'] ?? 0.0;
    final date = detail['date'] ?? 'Unknown date';
    final description = detail['description'] ?? 'No description';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: _getTypeColor(type).withAlpha(26),
          child: Icon(
            _getTypeIcon(type),
            size: 16,
            color: _getTypeColor(type),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _getTypeColor(type),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall,
              ),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'purchase':
        return Icons.shopping_cart;
      case 'interest':
        return Icons.percent;
      case 'late fee':
        return Icons.warning;
      case 'adjustment':
        return Icons.tune;
      default:
        return Icons.receipt;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'purchase':
        return Colors.blue;
      case 'interest':
        return Colors.orange;
      case 'late fee':
        return Colors.red;
      case 'adjustment':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
