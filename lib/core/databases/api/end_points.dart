class EndPoints {
  static const String baserUrl = "http://159.198.75.161:13000/api/v1/";
  static const String baserUrl1 = "http://159.198.75.161:13000/api/";

  static const String template = "template/";

  // Auth endpoints
  static const String addPharmacy = "pharmacy/complete-registration";
  static const String mangerLogin = "pharmacy/login";

  static const String addEmployee = "employees";
  static const String roleID = "roles";
  static String product = "search/all-products";
  static String pharmacyProduct = "pharmacy_products";
  static String masterProductDetails = "master_products";
  static String searchProduct = "search/products";
  static String form = "Forms";
  static String type = "types";
  static String manufacturers = "manufacturers";
  static String categories = "categories";
  static String suppliers = "suppliers";
  static String searchSuppliers = "suppliers/search";
  static String purchaseOrders = "purchase-orders";
  static String purchaseOrdersPaginated = "purchase-orders/paginated";
  static String purchaseInvoices = "purchase-invoices";
  static String purchaseInvoicesPaginated = "purchase-invoices/paginated";
}

class ApiKeys {
  // Common
  static const String id = "id";
  static const String name = "name";

  // Product
  static const String tradeName = "tradeName";
  static const String scientificName = "scientificName";
  static const String barcode = "barcode";
  static const String barcodes = "barcodes";
  static const String productType = "productTypeName";
  static const String requiresPrescription = "requiresPrescription";
  static const String concentration = "concentration";
  static const String size = "size";
  static const String type = "type";
  static const String form = "form";
  static const String manufacturer = "manufacturer";
  static const String notes = "notes";
  static const String categories = "categories";

  // Supplier
  static const String phone = "phone";
  static const String address = "address";
  static const String preferredCurrency = "preferredCurrency";

  // Orders

  static const String supplierName = "supplierName";
  static const String total = "total";
  static const String status = "status";
  static const String currency = "currency";
  static const String items = "items";
  static const String productItemId = "productId";
  static const String productItemName = "productName";
  static const String productItemType = "productType";
  static const String productItemQuantity = "quantity";
  static const String productItemPrice = "price";

  // Sales
  static const String createSale = 'sales';
  static const String cancelSale = 'cancel';

  // Purchase Invoice
  static const String purchaseOrderId = 'purchaseOrderId';
  static const String invoiceNumber = 'invoiceNumber';
  static const String createdAt = 'createdAt';
  static const String createdBy = 'createdBy';


  // Item keys
  static const String productName = 'productName';
  static const String receivedQty = 'receivedQty';
  static const String bonusQty = 'bonusQty';
  static const String invoicePrice = 'invoicePrice';
  static const String actualPrice = 'actualPrice';
  static const String batchNo = 'batchNo';
  static const String expiryDate = 'expiryDate';
}
