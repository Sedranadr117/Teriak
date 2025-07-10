import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/extensions/string.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/master_product/presentation/pages/product_details/subwidget/info_details_card_widget.dart' show InfoDetailsCardWidget;

class ProductDetailsBody extends StatefulWidget {
  final Map<String, dynamic> drugData;
  const ProductDetailsBody({
    super.key,
    required this.drugData,
  });

  @override
  State<ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<ProductDetailsBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoDetailsCardWidget(
          title: "Manufacturer".tr,
          child: Text(
            widget.drugData["manufacturer"] as String? ?? "N/A",
            style: Theme.of(context).textTheme.bodyLarge/*?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceLight,
                ),*/
          ),
        ),
        InfoDetailsCardWidget(
          title: "Pharmacological classification".tr,
          child: Text(
            widget.drugData["classification"] as String? ?? "N/A",
            style: Theme.of(context).textTheme.bodyLarge/*?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceLight,
                ),*/
          ),
        ),
        InfoDetailsCardWidget(
          title: "Product Type".tr,
          child: Text(
            widget.drugData["productType"] as String? ?? "N/A",
            style: Theme.of(context).textTheme.bodyLarge/*?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceLight,
                ),*/
          ),
        ),
        if (!(widget.drugData["barcode"] as String).isNullOrEmpty())
          InfoDetailsCardWidget(
            title: "Barcode",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.w * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.borderLight,
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
                          data: widget.drugData["barcode"] as String,
                          drawText: true,
                          style:
                              Theme.of(context).textTheme.bodySmall/*?.copyWith(
                                    fontSize: context.h * 0.015,
                                    color: AppColors.onSurfaceLight,
                                  ),*/
                        ),
                      ),
                      /* SizedBox(height: context.w * 0.02),
                                Text(
                                  "Long press to copy barcode",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textSecondaryLight,
                                      ),
                                ),*/
                    ],
                  ),
                ),
                SizedBox(height: context.w * 0.03),
                Text(
                  "Barcode: ${widget.drugData["barcode"]}",
                  style: Theme.of(context).textTheme.bodyLarge/*?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceLight,
                      ),*/
                ),
              ],
            ),
          ),
        if (!(widget.drugData["medicalNotes"] as String).isNullOrEmpty())
          InfoDetailsCardWidget(
            title: "Medical Notes".tr,
            child: Text(
              widget.drugData["medicalNotes"] as String,
              style: Theme.of(context).textTheme.bodyLarge/*?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceLight,
                  ),*/
            ),
          ),
      ],
    );
  }
}
