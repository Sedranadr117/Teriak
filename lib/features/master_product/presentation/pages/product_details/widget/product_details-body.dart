import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/string.dart';
import 'package:teriak/features/master_product/presentation/pages/product_details/subwidget/barcodes_widget.dart';
import 'package:teriak/features/master_product/presentation/pages/product_details/subwidget/info_details_card_widget.dart'
    show InfoDetailsCardWidget;

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
          child: Text(widget.drugData["manufacturer"] as String? ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge /*?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceLight,
                ),*/
              ),
        ),
        InfoDetailsCardWidget(
          title: "Pharmacological classification".tr,
          child: Text(widget.drugData["classification"] as String? ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge /*?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceLight,
                ),*/
              ),
        ),
        InfoDetailsCardWidget(
          title: "Product Type".tr,
          child: Text(widget.drugData["productType"] as String? ?? "N/A",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge /*?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceLight,
                ),*/
              ),
        ),
        // تعديل: عرض قائمة باركودات مع إمكانية الطي/الفتح
        Builder(
          builder: (context) {
            final List<String> barcodes =
                (widget.drugData["barcodes"] as List<dynamic>?)
                        ?.cast<String>() ??
                    [];
            if (barcodes.isEmpty) return SizedBox.shrink();
            return BarcodeExpandableList(barcodes: barcodes);
          },
        ),
        if (!(widget.drugData["medicalNotes"] as String).isNullOrEmpty())
          InfoDetailsCardWidget(
            title: "Medical Notes".tr,
            child: Text(widget.drugData["medicalNotes"] as String,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge /*?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceLight,
                  ),*/
                ),
          ),
      ],
    );
  }
}





