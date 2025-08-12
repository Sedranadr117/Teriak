import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/financial_overview_card.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/financial_records_card.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_action_widget.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_header_widget.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/widgets/supplier_info_widget.dart';

class SupplierDetailBottomSheetWidget extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SupplierDetailBottomSheetWidget({
    super.key,
    required this.supplier,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          SupplierHeaderWidget(
            name: supplier.name,
            preferredCurrency: supplier.preferredCurrency,
          ),
          SupplierInfoWidget(
            title: 'Contact Information',
            children: [
              SupplierInfoRow(
                iconName: 'phone',
                label: 'Phone',
                value: supplier.phone,
              ),
              SupplierInfoRow(
                iconName: 'location_on',
                label: 'Address',
                value: supplier.address,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          FinancialOverviewCard(supplier: supplier),
          SizedBox(height: 2.h),
          FinancialRecordsCard(supplier: supplier),
          SupplierActionsWidget(
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(top: 1.h),
      width: 12.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
