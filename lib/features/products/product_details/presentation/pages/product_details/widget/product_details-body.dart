import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/string.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/products/product_details/presentation/pages/product_details/subWidget/barcodes_widget.dart';
import 'package:teriak/features/products/product_details/presentation/pages/product_details/subWidget/info_details_card_widget.dart'
    show InfoDetailsCardWidget;

class ProductDetailsBody extends StatefulWidget {
  final ProductEntity drugData;
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
          child: Text(widget.drugData.manufacturer ?? "N/A",
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        widget.drugData.categories!.isEmpty?SizedBox():
        InfoDetailsCardWidget(
          title: "Pharmacological classification".tr,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.drugData.categories!.length,
            separatorBuilder: (_, __) => const Divider(height: 10),
            itemBuilder: (context, index) {
              return Text(
                widget.drugData.categories![index],
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
        ),
        if (!(widget.drugData.type as String).isNullOrEmpty())
        InfoDetailsCardWidget(
          title: "Product Type".tr,
          child: Text(widget.drugData.type ?? "N/A",
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        Builder(
          builder: (context) {
            final bool isPharmacy =
                (widget.drugData.productType == "Pharmacy") ||
                    (widget.drugData.productType == "صيدلية");

            if (isPharmacy) {
              final List<String> barcodes =
                  (widget.drugData.barcodes)?.cast<String>() ?? [];

              if (barcodes.isEmpty) return const SizedBox.shrink();

              return BarcodeExpandableList(barcodes: barcodes);
            } else {
              final String? barcode = widget.drugData.barcode;

              if (barcode == null || barcode.isEmpty) {
                return const SizedBox.shrink();
              }

              return BarcodeExpandableList(barcodes: [barcode]);
            }
          },
        ),
        if (!(widget.drugData.notes as String).isNullOrEmpty())
          InfoDetailsCardWidget(
            title: "Medical Notes".tr,
            child: Text(widget.drugData.notes as String,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
      ],
    );
  }
}
