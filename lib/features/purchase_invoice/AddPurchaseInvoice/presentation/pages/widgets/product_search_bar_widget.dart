import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductSearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final void Function()? onBarcodeScanned;

  const ProductSearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onBarcodeScanned,
  });

  @override
  State<ProductSearchBarWidget> createState() => _ProductSearchBarWidgetState();
}

class _ProductSearchBarWidgetState extends State<ProductSearchBarWidget> {
  String? lastScannedBarcode;
  final FocusNode _focusNode = FocusNode();

  @override
  void didUpdateWidget(ProductSearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تحديث الواجهة عند تغيير البيانات
    if (oldWidget.controller.text != widget.controller.text) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(
          horizontal: 4 * context.w / 100, vertical: 2 * context.h / 100),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.backgroundDark
                        : AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    onSubmitted: widget.onChanged,
                    decoration: InputDecoration(
                      hintText: 'Search products'.tr,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3 * context.w / 100),
                        child: const CustomIconWidget(
                          iconName: 'search',
                          color: AppColors.textSecondaryLight,
                          size: 20,
                        ),
                      ),
                      suffixIcon: IconButton(
                          padding: EdgeInsets.all(context.w * 0.03),
                          icon: CustomIconWidget(
                            iconName: 'qr_code',
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          onPressed: () async {
                            widget.onBarcodeScanned!();
                          }),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4 * context.w / 100,
                        vertical: 1.5 * context.h / 100,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // عرض الباركود الممسوح إذا كان موجوداً
          if (lastScannedBarcode != null && widget.controller.text.isEmpty)
            Container(
              margin: EdgeInsets.only(top: 1 * context.h / 100),
              padding: EdgeInsets.symmetric(
                  horizontal: 2 * context.w / 100,
                  vertical: 0.5 * context.h / 100),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code',
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 1 * context.w / 100),
                  Text(
                    '${'Last Barcode'.tr}: $lastScannedBarcode',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
