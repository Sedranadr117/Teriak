class EndPoints {
  static const String baserUrl = "http://89.116.236.10:13000/api/v1/";

  static const String template = "template/";

  // Auth endpoints
  static const String addPharmacy = "pharmacy/complete-registration";
  static const String mangerLogin = "pharmacy/login";
    static const String getAreas = "areas";


  //sale
  static const String sales = "sales";
  static const String searchInvoicesByRange = "sales/searchByDateRange";
  static const String salesRefunds = "sales/refunds";

  //customers
  static const String getCustomers = "customers";
  static const String createCustomer = "customers";
  static const String searchCustomers = "customers/search";
  static const String addPayment = "customer-debts/";
  static const String getCustomerDebts = "customer-debts/customer";

  //stock
  static const String getStock = "stock/products/Overall";
  static const String searchStock = "stock/search";
  static const String getDetailsStock = "stock/product";

  //user
  static const String addEmployee = "employees";
  static const String roleID = "roles";
  static const String getUserProfile = "users/me";

  static String product = "search/all-products";
  static String pharmacyProduct = "pharmacy_products";
  static String pharmacyProductNames = "pharmacy_products/multi-lang";
  static String masterProductNames = "master_products/multi-lang/";
  static String masterProductDetails = "master_products";
  static String searchProduct = "search/products";
  static String form = "Forms";
  static String type = "types";
  static String manufacturers = "manufacturers";
  static String categories = "categories";
  static String suppliers = "suppliers";
  static String searchSuppliers = "suppliers/search";
  static String purchaseOrders = "purchase-orders";
  static String purchaseInvoices = "purchase-invoices";
  static String purchaseOrderSearchBySupplier = "purchase-orders/supplier";
  static String purchaseOrderSearchByDateRange = "purchase-orders/time-range";
  static String purchaseInvoicesSearchBySupplier = "purchase-invoices/supplier";
  static String purchaseInvoicesSearchByDateRange =
      "purchase-invoices/time-range";
  static String moneyBox = "moneybox";
  static String moneyBoxTransactions = "moneybox/transactions";
  static String moneyBoxReconcile = "moneybox/reconcile";
  static String moneyBoxCurrencyRates = "moneybox/currency/rates";
  static String moneyBoxCurrencyConvert = "moneybox/currency/convert";
}

class ApiKeys {
  // Common
  static const String id = "id";
  static const String name = "name";

  // Product
  static const String tradeName = "tradeName";
  static const String scientificName = "scientificName";
  static const String tradeNameAr = "tradeNameAr";
  static const String tradeNameEn = "tradeNameEn";
  static const String scientificNameAr = "scientificNameAr";
  static const String scientificNameEn = "scientificNameEn";
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
  static const String supplierId = "supplierId";
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
  static const String refPurchasePrice = "refPurchasePrice";
  static const String refSellingPrice = "refSellingPrice";
  static const String refPurchasePriceUSD = "refPurchasePriceUSD";
  static const String refSellingPriceUSD = "refSellingPriceUSD";
  static const String minStockLevel = "minStockLevel";
  static const String tax = "tax";

  // Purchase Invoice
  static const String purchaseOrderId = 'purchaseOrderId';
  static const String invoiceNumber = 'invoiceNumber';
  static const String createdAt = 'createdAt';
  static const String createdBy = 'createdBy';
  static const String page = 'page';

  // Item keys
  static const String productName = 'productName';
  static const String receivedQty = 'receivedQty';
  static const String bonusQty = 'bonusQty';
  static const String invoicePrice = 'invoicePrice';
  static const String actualPrice = 'actualPrice';
  static const String batchNo = 'batchNo';
  static const String expiryDate = 'expiryDate';

  static const String lastReconciled = 'lastReconciled';
  static const String totalBalanceInSYP = 'totalBalanceInSYP';
  static const String totalBalanceInUSD = 'totalBalanceInUSD';
  static const String currentUSDToSYPRate = 'currentUSDToSYPRate';

  static const String balanceAfter = 'balanceAfter';
  static const String balanceBefore = 'balanceBefore';
  static const String amount = 'amount';
  static const String transactionType = 'transactionType';
  static const String description = 'description';
}
