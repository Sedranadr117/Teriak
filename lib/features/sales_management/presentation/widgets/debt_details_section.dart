import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/sales_management/presentation/controllers/sale_controller.dart';

class DebtDetailsSection extends StatelessWidget {
  final TextEditingController debtAmountController;
  final DateTime dueDate;
  final Function() onDueDateChanged;

  const DebtDetailsSection({
    super.key,
    required this.debtAmountController,
    required this.dueDate,
    required this.onDueDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: debtAmountController,
          onChanged: (value) {
            final parsed = double.tryParse(value) ?? 0.0;
            final saleController = Get.put(SaleController(customerTag: ''));
            saleController.defferredAmount.value = parsed;
          },
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: 'Add the deferred amount'.tr,
            prefixIcon: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Icon(
                Icons.money,
                size: 20.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
          ),
        ),
        SizedBox(height: 2.h),
        InkWell(
          onTap: onDueDateChanged,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due Date'.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
