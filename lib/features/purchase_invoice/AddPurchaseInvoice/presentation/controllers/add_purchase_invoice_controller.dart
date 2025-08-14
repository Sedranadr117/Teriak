import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_item_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';

class AddPurchaseInvoiceController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumberController = TextEditingController();
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Observable variables
  final Rx<PurchaseOrderModel?> _purchaseOrder = Rx<PurchaseOrderModel?>(null);
  final RxList<Map<String, dynamic>> _products = <Map<String, dynamic>>[].obs;
  final RxBool _isSaving = false.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _hasUnsavedChanges = false.obs;

  // Getters
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get invoiceNumberController => _invoiceNumberController;
  TextEditingController get searchController => _searchController;
  ScrollController get scrollController => _scrollController;
  PurchaseOrderModel? get purchaseOrder => _purchaseOrder.value;
  List<Map<String, dynamic>> get products => _products;
  bool get isSaving => _isSaving.value;
  String get searchQuery => _searchQuery.value;
  bool get hasUnsavedChanges => _hasUnsavedChanges.value;

  @override
  void onInit() {
    super.onInit();
    _generateInvoiceNumber();
  }

  @override
  void onClose() {
    _invoiceNumberController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.onClose();
  }

  void setPurchaseOrder(PurchaseOrderModel po) {
    _purchaseOrder.value = po;
    _generateProductsFromPO(po);
  }

  void _generateInvoiceNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
    _invoiceNumberController.text = 'INV-${DateFormat('yyyy')}-$timestamp';
  }

  void _generateProductsFromPO(PurchaseOrderModel po) {
    final List<Map<String, dynamic>> products = po.items
        .map((item) => {
              "id": item.id,
              "name": item.productName,
              "sku": item.productId,
              "barcode": item.barcode,
              "requiredQuantity": item.quantity,
              "unitPrice": item.price,
              "receivedQuantity": 0,
              "bonusQuantity": 0,
              "minStockLevel": 10,
              "batchNumber": "",
              "expiryDate": null,
              "actualPurchasePrice": item.price,
              "isSelected": false,
            })
        .toList();

    _products.assignAll(products);
  }

  void onSearchChanged(String query) {
    _searchQuery.value = query.toLowerCase();

    if (query.isNotEmpty) {
      _scrollToMatchingProduct(query);
    }
  }

  void _scrollToMatchingProduct(String query) {
    for (int i = 0; i < _products.length; i++) {
      final product = _products[i];
      if (product['name'].toLowerCase().contains(query) ||
          product['barcode'].contains(query) ||
          product['sku'].toLowerCase().contains(query)) {
        final position = i * 120.0;
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
      }
    }
  }

  void onBarcodeScanned(String barcode) {
    _searchController.text = barcode;
    onSearchChanged(barcode);

    for (int i = 0; i < _products.length; i++) {
      if (_products[i]['barcode'] == barcode) {
        _scrollToMatchingProduct(barcode);
        break;
      }
    }
  }

  void onProductDataChanged(int index, Map<String, dynamic> updatedData) {
    _products[index] = {..._products[index], ...updatedData};
    _hasUnsavedChanges.value = true;
    _autoSave();
  }

  void _autoSave() {
    // Implement auto-save functionality
  }

  void autoSave() {
    _autoSave();
  }

  double calculateTotalAmount() {
    double total = 0.0;
    for (final product in _products) {
      final receivedQty = product['receivedQuantity'] as int;
      final bonusQty = product['bonusQuantity'] as int;
      final actualPrice = product['actualPurchasePrice'] as double;

      if (receivedQty > 0) {
        final totalQty = receivedQty + bonusQty;
        final unitCost =
            totalQty > 0 ? (receivedQty * actualPrice) / totalQty : actualPrice;
        total += receivedQty * unitCost;
      }
    }
    return total;
  }

  int getTotalReceivedItems() {
    return _products.fold(
        0, (sum, product) => sum + (product['receivedQuantity'] as int));
  }

  int getTotalBonusItems() {
    return _products.fold(
        0, (sum, product) => sum + (product['bonusQuantity'] as int));
  }

  bool validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    final hasReceivedProducts =
        _products.any((product) => (product['receivedQuantity'] as int) > 0);
    if (!hasReceivedProducts) {
      return false;
    }

    return true;
  }

  Future<bool> saveInvoice() async {
    if (!validateForm()) {
      return false;
    }

    _isSaving.value = true;

    try {
      // Simulate API call to save invoice
      await Future.delayed(const Duration(seconds: 2));

      // Create PurchaseInvoiceModel
      final invoice = PurchaseInvoiceModel(
        id: DateTime.now().millisecondsSinceEpoch,
        purchaseOrderId:
            int.tryParse(_purchaseOrder.value?.id.toString() ?? '0') ?? 0,
        supplierName: _purchaseOrder.value?.supplierName ?? '',
        currency: _purchaseOrder.value?.currency ?? 'USD',
        total: calculateTotalAmount(),
        invoiceNumber: _invoiceNumberController.text,
        createdAt: [
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second,
        ],
        createdBy: 1, // Replace with actual user ID
        items: _products
            .where((p) => (p['receivedQuantity'] as int) > 0)
            .map((product) => PurchaseInvoiceItemModel(
                  id: int.tryParse(product['id'].toString()) ?? 0,
                  productName: product['name'],
                  receivedQty: product['receivedQuantity'],
                  bonusQty: product['bonusQuantity'],
                  invoicePrice: product['unitPrice'],
                  actualPrice: product['actualPurchasePrice'],
                  batchNo: product['batchNumber'] ?? '',
                  expiryDate: product['expiryDate'] != null
                      ? [
                          (product['expiryDate'] as DateTime).year,
                          (product['expiryDate'] as DateTime).month,
                          (product['expiryDate'] as DateTime).day,
                        ]
                      : [
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day
                        ],
                ))
            .toList(),
      );

      // Here you would typically save the invoice to your backend
      // For now, we'll just mark as saved
      _hasUnsavedChanges.value = false;

      return true;
    } catch (e) {
      return false;
    } finally {
      _isSaving.value = false;
    }
  }

  void markAsChanged() {
    _hasUnsavedChanges.value = true;
  }

  void clearUnsavedChanges() {
    _hasUnsavedChanges.value = false;
  }
}
