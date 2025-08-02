import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class BarcodeManagementCard extends StatelessWidget {
  final List<String> barcodes;
  final TextEditingController barcodeController;
  final VoidCallback onAddBarcode;
  final Function(int) onRemoveBarcode;
  final VoidCallback onScanBarcode;

  const BarcodeManagementCard({
    super.key,
    required this.barcodes,
    required this.barcodeController,
    required this.onAddBarcode,
    required this.onRemoveBarcode,
    required this.onScanBarcode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.w * 0.04,
        vertical: context.h * 0.01,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 4.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: context.w * 0.02),
                Text(
                  'Barcode'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text(
                  ' *',
                  style:
                      TextStyle(color: AppColors.errorLight, fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(height: context.h * 0.03),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: TextFormField(
                      controller: barcodeController,
                      decoration: InputDecoration(
                        hintText: "barcode Hint".tr,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: context.w * 0.04,
                          vertical: context.h * 0.02,
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(context.w * 0.03),
                          child: CustomIconWidget(
                            iconName: 'qr_code',
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.w * 0.02),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: onAddBarcode,
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.h * 0.02),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onScanBarcode,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  padding: EdgeInsets.symmetric(vertical: context.h * 0.02),
                ),
                icon: CustomIconWidget(
                  iconName: 'camera_alt',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  'scan'.tr,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (barcodes.isNotEmpty) ...[
              SizedBox(height: context.h * 0.02),
              Text(
                'Added Barcodes'.tr,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: context.h * 0.01),
              ...barcodes.asMap().entries.map((entry) {
                final index = entry.key;
                final barcode = entry.value;
                return Container(
                  margin: EdgeInsets.only(bottom: context.h * 0.01),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w * 0.03,
                    vertical: context.h * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                    borderRadius: BorderRadius.circular(context.w * 0.02),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'qr_code',
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: context.w * 0.02),
                      Expanded(
                        child: Text(
                          barcode,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontFamily: 'monospace',
                                  ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => onRemoveBarcode(index),
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: Theme.of(context).colorScheme.error,
                          size: 16,
                        ),
                        constraints: BoxConstraints(
                          minWidth: context.w * 0.06,
                          minHeight: context.w * 0.06,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
