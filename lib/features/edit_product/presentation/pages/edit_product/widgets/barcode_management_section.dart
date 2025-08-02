import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';


class BarcodeManagementSection extends StatelessWidget {
  final List<String> barcodes;
  final TextEditingController barcodeController;
  final VoidCallback onAddBarcode;
  final Function(int) onRemoveBarcode;
  final VoidCallback onScanBarcode;
  final bool isExpanded;
  final VoidCallback onToggle;

  const BarcodeManagementSection({
    super.key,
    required this.barcodes,
    required this.barcodeController,
    required this.onAddBarcode ,
    required this.onRemoveBarcode ,
    required this.onScanBarcode ,
    this.isExpanded = false,
    required this.onToggle,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
     final isDark = theme.brightness == Brightness.dark;
     final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.w * 0.04,
        vertical: context.h * 0.02,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(context.w * 0.05),
        border: Border(
          left: BorderSide(
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
            width: 4.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, context.h * 0.005),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.all(context.w * 0.04),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code_scanner',
                   color: colorScheme.primary,
                    size: context.w * 0.06,
                  ),
                  SizedBox(width: context.w * 0.03),
                  Expanded(
                    child: Text(
                      'Barcode'.tr,
                     style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                    ),
                  ),
                  if (barcodes.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w * 0.02,
                        vertical: context.h * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(context.w * 0.05),
                      ),
                      child: Text(
                        '${barcodes.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SizedBox(width: context.w * 0.02),
                  CustomIconWidget(
                    iconName: isExpanded ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.onSurface,
                    size: context.w * 0.06,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: context.h * 0.005,
              color: Colors.grey.withValues(alpha: 0.2),
            ),
            Padding(
              padding: EdgeInsets.all(context.w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barcode Input Section
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(
                              context.w * 0.02,
                            ),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                            ),
                          ),
                          child: TextFormField(
                            controller: barcodeController,
                            decoration: InputDecoration(
                              hintText: 'barcode Hint'.tr,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: context.w * 0.04,
                                vertical: context.h * 0.015,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(context.w * 0.03),
                                child: CustomIconWidget(
                                  iconName: 'qr_code',
                                  color: Colors.grey,
                                  size: context.w * 0.05,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.w * 0.02),
                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(context.w * 0.02),
                        ),
                        child: IconButton(
                          onPressed: onAddBarcode,
                          icon: CustomIconWidget(
                            iconName: 'add',
                            color: Colors.white,
                            size: context.w * 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.h * 0.02),

                  // Scan Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onScanBarcode,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: colorScheme.primary,
                          width: context.w * 0.005,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: context.h * 0.015,
                        ),
                      ),
                      icon: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: colorScheme.primary,
                        size: context.w * 0.05,
                      ),
                      label: Text(
                        'scan'.tr,
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // Barcodes List
                  if (barcodes.isNotEmpty) ...[
                    SizedBox(height: context.h * 0.02),
                    Text(
                      'Added Barcodes'.tr,
                      style: theme.textTheme.labelLarge?.copyWith(
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
                          color: colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(context.w * 0.02),
                          border: Border.all(
                            color: colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'qr_code',
                              color: colorScheme.primary,
                              size: context.w * 0.04,
                            ),
                            SizedBox(width: context.w * 0.02),
                            Expanded(
                              child: Text(
                                barcode,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => onRemoveBarcode(index),
                              icon: CustomIconWidget(
                                iconName: 'close',
                                color: AppColors.errorLight,
                                size: context.w * 0.04,
                              ),
                              constraints: BoxConstraints(
                                minWidth: context.w * 0.06,
                                minHeight: context.h * 0.06,
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
          ],
        ],
      ),
    );
  }
}
