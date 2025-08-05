import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';



class FinancialRecordsCard extends StatelessWidget {
  final Map<String, dynamic> supplier;

  const FinancialRecordsCard({
    super.key,
    required this.supplier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock financial records for demonstration
    final List<Map<String, dynamic>> financialRecords = [
      {
        "id": 1,
        "type": "payment",
        "amount": 2500.00,
        "description": "Payment for office supplies",
        "date": DateTime.now().subtract(Duration(days: 5)),
        "status": "completed",
      },
      {
        "id": 2,
        "type": "debt",
        "amount": 1200.00,
        "description": "Outstanding invoice #INV-2024-001",
        "date": DateTime.now().subtract(Duration(days: 12)),
        "status": "pending",
      },
      {
        "id": 3,
        "type": "payment",
        "amount": 800.00,
        "description": "Partial payment received",
        "date": DateTime.now().subtract(Duration(days: 18)),
        "status": "completed",
      },
    ];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'receipt_long',
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      "Financial Records",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("View all records feature coming soon"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    "View All",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            financialRecords.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: financialRecords.length > 3
                        ? 3
                        : financialRecords.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final record = financialRecords[index];
                      return _buildRecordItem(context, record);
                    },
                  ),
            if (financialRecords.length > 3) ...[
              SizedBox(height: 2.h),
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Show more records feature coming soon"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    "Show ${financialRecords.length - 3} more records",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'receipt_long',
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            "No Financial Records",
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Financial transactions will appear here",
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(BuildContext context, Map<String, dynamic> record) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isPayment = record["type"] == "payment";
    final amount = record["amount"] as double;
    final description = record["description"] as String;
    final date = record["date"] as DateTime;
    final status = record["status"] as String;
    final currency = supplier["preferredCurrency"] as String;

    final recordColor = isPayment
        ? Theme.of(context).colorScheme.tertiary
        : colorScheme.error;

    final statusColor = status == "completed"
        ? Theme.of(context).colorScheme.tertiary
        : colorScheme.error;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: recordColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: isPayment ? 'arrow_downward' : 'arrow_upward',
                color: recordColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "${isPayment ? '+' : '-'}${amount.toStringAsFixed(2)} $currency",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: recordColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
