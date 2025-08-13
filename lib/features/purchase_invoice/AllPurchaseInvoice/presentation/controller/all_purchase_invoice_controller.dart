import 'package:get/get.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';

class AllPurchaseInvoiceController extends GetxController {
  // Variables for invoices
  var isLoadingInvoices = true.obs;
  var invoices = [].obs;
  var errorMessageInvoices = ''.obs;
  var isRefreshingInvoices = false.obs;

  // Variables for purchase orders (PENDING only)
  var isLoadingOrders = true.obs;
  var purchaseOrders = <PurchaseOrderModel>[].obs;
  var errorMessageOrders = ''.obs;
  var selectedOrderId = Rxn<int>();

  // Pagination variables for invoices
  var currentPage = 0.obs;
  var pageSize = 10.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasNext = false.obs;
  var hasPrevious = false.obs;
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
    loadPendingPurchaseOrders();
  }

  // Load invoices
  void loadInvoices({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        isLoadingInvoices.value = true;
      } else {
        isLoadingInvoices.value = true;
      }

      // TODO: Implement API call to load invoices
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API call
      final mockInvoices = [
        PurchaseInvoiceEntity(
          id: 1,
          purchaseOrderId: 1,
          supplierName: 'شركة الأدوية المتحدة',
          currency: 'USD',
          total: 550.0,
          invoiceNumber: 'INV-001',
          createdAt: [2025, 8, 11, 10, 12, 6, 845595000],
          createdBy: 3354,
          items: [],
        ),
        PurchaseInvoiceEntity(
          id: 2,
          purchaseOrderId: 2,
          supplierName: 'مصنع الدواء الحديث',
          currency: 'SYP',
          total: 125000.0,
          invoiceNumber: 'INV-002',
          createdAt: [2025, 8, 10, 15, 30, 0, 0],
          createdBy: 3354,
          items: [],
        ),
      ];

      if (refresh) {
        invoices.value = mockInvoices;
      } else {
        invoices.value = mockInvoices;
      }

      totalElements.value = mockInvoices.length;
      totalPages.value = 1;
      hasNext.value = false;
      hasPrevious.value = false;
    } catch (e) {
      errorMessageInvoices.value = 'Failed to load invoices'.tr;
      print('Error loading invoices: $e');
    } finally {
      isLoadingInvoices.value = false;
    }
  }

  // Load pending purchase orders
  void loadPendingPurchaseOrders() async {
    try {
      isLoadingOrders.value = true;

      // TODO: Implement API call to load PENDING purchase orders
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API call
      final mockOrders = [
        PurchaseOrderModel(
          id: 1,
          supplierName: 'شركة الأدوية المتحدة',
          currency: 'USD',
          total: 550.0,
          status: 'PENDING',
          items: [],
        ),
        PurchaseOrderModel(
          id: 2,
          supplierName: 'مصنع الدواء الحديث',
          currency: 'SYP',
          total: 125000.0,
          status: 'PENDING',
          items: [],
        ),
      ];

      // Filter only PENDING orders
      purchaseOrders.value =
          mockOrders.where((order) => order.status == 'PENDING').toList();
    } catch (e) {
      errorMessageOrders.value = 'Failed to load purchase orders'.tr;
      print('Error loading purchase orders: $e');
    } finally {
      isLoadingOrders.value = false;
    }
  }

  // Select purchase order
  void selectPurchaseOrder(int orderId) {
    selectedOrderId.value = orderId;
  }

  // Get selected order
  PurchaseOrderModel? get selectedOrder {
    if (selectedOrderId.value == null) return null;
    try {
      return purchaseOrders
          .firstWhere((order) => order.id == selectedOrderId.value);
    } catch (e) {
      return null;
    }
  }

  // Refresh invoices
  Future<void> refreshInvoices() async {
    try {
      isRefreshingInvoices.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      loadInvoices(refresh: true);
    } finally {
      isRefreshingInvoices.value = false;
    }
  }

  // Load next page of invoices
  Future<void> loadNextPage() async {
    if (hasNext.value && !isLoadingMore.value) {
      try {
        isLoadingMore.value = true;
        currentPage.value++;

        // TODO: Implement API call to load next page
        await Future.delayed(const Duration(seconds: 1));

        // Mock data for next page
        final nextPageInvoices = [
          PurchaseInvoiceEntity(
            id: 3,
            purchaseOrderId: 3,
            supplierName: 'شركة الأدوية العالمية',
            currency: 'USD',
            total: 750.0,
            invoiceNumber: 'INV-003',
            createdAt: [2025, 8, 9, 12, 0, 0, 0],
            createdBy: 3354,
            items: [],
          ),
        ];

        invoices.addAll(nextPageInvoices);
        hasNext.value = false; // No more pages for mock data
      } catch (e) {
        errorMessageInvoices.value = 'Failed to load more invoices'.tr;
        print('Error loading next page: $e');
      } finally {
        isLoadingMore.value = false;
      }
    }
  }

  // Clear errors
  void clearErrors() {
    errorMessageInvoices.value = '';
    errorMessageOrders.value = '';
  }
}
