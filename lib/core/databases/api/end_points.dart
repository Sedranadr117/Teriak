class EndPoints {
  static const String baserUrl = "http://159.198.75.161:13000/api/v1/";
  static const String baserUrl1 = "http://159.198.75.161:13000/api/";

  static const String template = "template/";

  // Auth endpoints
  static const String addPharmacy = "pharmacy/complete-registration";
  static const String mangerLogin = "pharmacy/login";

  static const String createSale = "sales";
  static const String getCustomers = "customers";
  static const String searchCustomers = "customers/search";

  static const String getStock = "sales";
  static const String getSales = "sales";

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
}

class ApiKeys {
  static const String id = "id";
  static const String name = "name";
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
  static const String refPurchasePrice = "refPurchasePrice";

  static const String refSellingPrice = "refSellingPrice";
  static const String tax = "tax";
}
