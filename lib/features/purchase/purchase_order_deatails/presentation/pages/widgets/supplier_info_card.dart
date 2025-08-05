import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class SupplierInfoCard extends StatelessWidget {
  final Map<String, dynamic> supplierData;
  final String currency;

  const SupplierInfoCard({
    super.key,
    required this.supplierData,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'business',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'معلومات المورد',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildInfoRow(
              context,
              'الاسم',
              supplierData['name'] as String? ?? 'غير محدد',
              'person',
            ),
            SizedBox(height: 1.5.h),
            _buildInfoRow(
              context,
              'رقم الهاتف',
              supplierData['phone'] as String? ?? 'غير متوفر',
              'phone',
            ),
            SizedBox(height: 1.5.h),
            _buildInfoRow(
              context,
              'البريد الإلكتروني',
              supplierData['email'] as String? ?? 'غير متوفر',
              'email',
            ),
            SizedBox(height: 1.5.h),
            _buildInfoRow(
              context,
              'العنوان',
              supplierData['address'] as String? ?? 'غير محدد',
              'location_on',
            ),
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'attach_money',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'العملة المحددة: ${_getCurrencyDisplay(currency)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
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

  Widget _buildInfoRow(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 18,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCurrencyDisplay(String currency) {
    switch (currency.toLowerCase()) {
      case 'syp':
      case 'syrian pound':
        return 'ليرة سورية (SYP)';
      case 'usd':
      case 'us dollar':
        return 'دولار أمريكي (USD)';
      default:
        return currency;
    }
  }
}
