import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/products/add_product/presentation/pages/add_product/add_product.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/bottom_sheet_management/barcode_bottom_sheet.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/pages/widgets/unified_card.dart';

class ProductSelectionCard extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(ProductEntity) onProductSelected;
  final Function(String) onBarcodeScanned;
  final ProductEntity? selectedProduct;
  final TextEditingController barcodeController;
  final TextEditingController quantityController;
  final TextEditingController priceController;
  final int currentQuantity;
  final double currentPrice;

  final Function(int) onQuantityChanged;
  final Function(double) onPriceChanged;
  final VoidCallback onAddProduct;
  final String? productError;
  final String? quantityError;
  final String? priceError;

  const ProductSelectionCard({
    super.key,
    required this.products,
    required this.onProductSelected,
    required this.onBarcodeScanned,
    this.selectedProduct,
    required this.barcodeController,
    required this.quantityController,
    required this.priceController,
    required this.currentQuantity,
    required this.currentPrice,
    required this.onQuantityChanged,
    required this.onPriceChanged,
    required this.onAddProduct,
    this.productError,
    this.quantityError,
    this.priceError,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedCard(
      iconName: 'medical_services',
      title: 'Product Selection'.tr,
      children: [
        _buildProductSelection(),
        SizedBox(height: 1.2.h),
        _buildBarcodeSection(),
        SizedBox(height: 1.2.h),
        _buildQuantityPriceSection(),
        if (selectedProduct != null) ...[
          SizedBox(height: 1.2.h),
          _buildProductDetails(),
        ],
        SizedBox(height: 1.6.h),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildProductSelection() {
    return Builder(builder: (context) {
      // Ensure we have unique products based on ID
      final uniqueProducts = products.fold<List<ProductEntity>>(
        [],
        (list, product) {
          if (!list.any((p) =>
              p.id == product.id && p.productType == product.productType)) {
            list.add(product);
          }
          return list;
        },
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Product'.tr,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 0.8.h),
          Row(
            children: [
              Expanded(
                child: UnifiedDropdown<ProductEntity>(
                  hint: 'Select Product'.tr,
                  value: selectedProduct,
                  items: uniqueProducts,
                  itemText: (product) => product.tradeName,
                  onChanged: (product) {
                    if (product != null) {
                      print('Product type: ${selectedProduct?.productType}');
                      onProductSelected(product);
                    }
                  },
                  errorText: productError,
                ),
              ),
              SizedBox(width: context.w * 0.02),
              Container(
                decoration: BoxDecoration(
                  color:  Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () async {
                    final result = await Get.toNamed(AppPages.addProductPage);
                  },
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          if (productError != null) ...[
            SizedBox(height: 0.8.h),
            UnifiedErrorText(errorText: productError!),
          ],
        ],
      );
    });
  }

  Widget _buildBarcodeSection() {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter or scan barcode'.tr,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 0.8.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: barcodeController,
                  decoration: InputDecoration(
                    hintText: 'Barcode'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        final barcode = barcodeController.text.trim();
                        if (barcode.isNotEmpty) {
                          onBarcodeScanned(barcode);
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        color: AppColors.primaryLight,
                        size: 5.w,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 12.sp),
                  onFieldSubmitted: (value) {
                    if (value.isNotEmpty) {
                      onBarcodeScanned(value);
                    }
                  },
                ),
              ),
              SizedBox(width: 1.w),
              IconButton(
                onPressed: () {
                  showBarcodeScannerBottomSheet(
                    onScanned: onBarcodeScanned,
                  );
                },
                icon: Icon(
                  Icons.qr_code_scanner,
                  color: AppColors.primaryLight,
                  size: 6.w,
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      AppColors.primaryLight.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  // Helper method to check if product type is pharmacy
  bool _isPharmacyProduct() {
    if (selectedProduct?.productType == null) return false;
    final productType = selectedProduct!.productType;
    return productType == "Pharmacy" || productType == "صيدلية";
  }

  // Helper method to check if product type is master
  bool _isMasterProduct() {
    if (selectedProduct?.productType == null) return false;
    final productType = selectedProduct!.productType;
    return productType == "Master" || productType == "مركزي";
  }

  Widget _buildQuantityPriceSection() {
    final bool isPriceEditable = _isPharmacyProduct();
    final bool isMaster = _isMasterProduct();

    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details'.tr,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 0.8.h),
          Row(
            children: [
              // Quantity Field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Quantity'.tr,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: 0.6.h),
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: quantityError != null
                                ? AppColors.errorLight
                                : AppColors.borderLight,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                      ),
                      style: TextStyle(fontSize: 12.sp),
                      onChanged: (value) {
                        final quantity = int.tryParse(value);
                        if (quantity != null) {
                          onQuantityChanged(quantity);
                        }
                      },
                    ),
                    if (quantityError != null) ...[
                      SizedBox(height: 0.4.h),
                      UnifiedErrorText(errorText: quantityError!),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              // Price Field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Price'.tr,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: 0.6.h),
                    TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      readOnly:
                          !isPriceEditable, // Can edit only if pharmacy product
                      decoration: InputDecoration(
                        hintText: '0.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: priceError != null
                                ? AppColors.errorLight
                                : AppColors.borderLight,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        suffixIcon: !isPriceEditable
                            ? Icon(
                                Icons.lock,
                                color: AppColors.textSecondaryLight,
                                size: 4.w,
                              )
                            : null,
                        filled: !isPriceEditable,
                        fillColor: !isPriceEditable
                            ? AppColors.borderLight.withOpacity(0.1)
                            : null,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: !isPriceEditable
                            ? AppColors.textSecondaryLight
                            : AppColors.textSecondaryLight,
                      ),
                      onChanged: (value) {
                        if (isPriceEditable) {
                          final price = double.tryParse(value);
                          if (price != null) {
                            onPriceChanged(price);
                          }
                        }
                      },
                    ),
                    if (priceError != null) ...[
                      SizedBox(height: 0.4.h),
                      UnifiedErrorText(errorText: priceError!),
                    ],
                    if (!isPriceEditable && selectedProduct != null) ...[
                      SizedBox(height: 0.4.h),
                      Text(
                        isMaster
                            ? 'Price is fixed for master products'.tr
                            : 'Price is readonly for this product type'.tr,
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Line Total Display
          SizedBox(height: 1.h),
          if (currentQuantity > 0 && currentPrice > 0) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 3.w,
              ),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.successLight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Line Total'.tr,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    '${(currentQuantity * currentPrice).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildProductDetails() {
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.all(2.5.w),
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primaryLight.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Product Info'.tr,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 0.6.h),
            _buildDetailRow('Product Name'.tr, selectedProduct!.tradeName),
            _buildDetailRow(
                'Scientific Name'.tr, selectedProduct!.scientificName),
            if (selectedProduct!.manufacturer != null &&
                selectedProduct!.manufacturer!.isNotEmpty)
              _buildDetailRow(
                  'Manufacturer'.tr, selectedProduct!.manufacturer ?? ''),
            if (selectedProduct!.type != null &&
                selectedProduct!.type!.isNotEmpty)
              _buildDetailRow('Product Type'.tr, selectedProduct!.type ?? ''),
            if (selectedProduct!.barcodes != null &&
                selectedProduct!.barcodes!.isNotEmpty)
              _buildDetailRow(
                  'Barcode'.tr, selectedProduct!.barcodes?.first ?? ''),
          ],
        ),
      );
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(bottom: 0.3.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondaryLight,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.appColor4
                      : AppColors.primaryLight,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAddButton() {
    final bool canAdd =
        selectedProduct != null && currentQuantity > 0 && currentPrice > 0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canAdd ? onAddProduct : null,
        icon: Icon(Icons.add, size: 4.w),
        label: Text('Add Product'.tr),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canAdd ? AppColors.primaryLight : AppColors.textDisabledLight,
          foregroundColor: AppColors.onPrimaryLight,
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }
}
