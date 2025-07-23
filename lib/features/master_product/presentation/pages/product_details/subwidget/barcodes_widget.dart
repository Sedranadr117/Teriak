import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/master_product/presentation/pages/product_details/subwidget/info_details_card_widget.dart';

class BarcodeExpandableList extends StatefulWidget {
  final List<String> barcodes;
  const BarcodeExpandableList({Key? key, required this.barcodes});

  @override
  State<BarcodeExpandableList> createState() => _BarcodeExpandableListState();
}

class _BarcodeExpandableListState extends State<BarcodeExpandableList> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return InfoDetailsCardWidget(
      title: "Barcode".tr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Text(_expanded ? "Hide Barcodes".tr : "Show Barcodes".tr,
                    style: Theme.of(context).brightness == Brightness.dark
                        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                        : Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          if (_expanded)
            Column(
              children: widget.barcodes.map((barcode) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: context.w * 0.02),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.w * 0.04),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.cardDark
                          : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: context.h * 0.11,
                          width: double.infinity,
                          child: BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: barcode,
                            drawText: true,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        SizedBox(height: context.w * 0.02),
                        Text(
                          "Barcode: $barcode",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
