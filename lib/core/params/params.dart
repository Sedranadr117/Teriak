// ignore_for_file: public_member_api_docs, sort_constructors_first
class TemplateParams {
  final String id;
  TemplateParams({required this.id});
}

class AuthParams {
  final String? id;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? role;
  final AuthType authType;

  AuthParams({
    this.id,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.role,
    required this.authType,
  });
}

class PhaParams {
  final String? newPassword;
  final String? location;
  final String? managerFirstName;
  final String? managerLastName;
  final String? pharmacyPhone;
  final String? pharmacyEmail;
  final String? openingHours;
  final int? areaId;
  PhaParams(
      this.newPassword,
      this.location,
      this.managerFirstName,
      this.managerLastName,
      this.pharmacyPhone,
      this.pharmacyEmail,
      this.openingHours,
      this.areaId);
}

class EmployeeParams {
  final String firstName;
  final String lastName;
  final String password;
  final String phoneNumber;
  final String status;
  final String dateOfHire;
  final int roleId;
  final List<WorkingHoursRequestParams> workingHoursRequests;

  const EmployeeParams(
    this.firstName,
    this.lastName,
    this.password,
    this.phoneNumber,
    this.status,
    this.dateOfHire,
    this.roleId,
    this.workingHoursRequests,
  );
}

class WorkingHoursRequest {
  final List<WorkingHoursRequestParams> workingHoursRequests;

  const WorkingHoursRequest(this.workingHoursRequests,
      {required List<String> daysOfWeek});

  Map<String, dynamic> toJson() {
    return {
      "workingHoursRequests":
          workingHoursRequests.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkingHoursRequestParams {
  final List<String> daysOfWeek;
  final List<ShiftParams> shifts;

  const WorkingHoursRequestParams({
    required this.daysOfWeek,
    required this.shifts,
  });

  Map<String, dynamic> toJson() {
    return {
      "daysOfWeek": daysOfWeek,
      "shifts": shifts.map((shift) => shift.toJson()).toList(),
    };
  }
}

class ShiftParams {
  final String startTime;
  final String endTime;
  final String description;

  const ShiftParams(
    this.startTime,
    this.endTime,
    this.description,
  );

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
    };
  }
}

enum AuthType {
  mangerLogin,
  logout,
}

class ProductDetailsParams {
  final int id;
  String? type;
  final String languageCode;
  ProductDetailsParams(
      {required this.id, required this.languageCode, this.type});
  Map<String, dynamic> toMap() {
    return {
      'lang': languageCode,
    };
  }
}

class SearchProductParams {
  final String keyword;
  final String languageCode;
  final int page;
  final int size;

  const SearchProductParams({
    required this.keyword,
    required this.languageCode,
    required this.page,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'keyword': keyword,
      'lang': languageCode,
      'page': page.toString(),
      'size': size.toString(),
    };
  }
}

class AllProductParams {
  final String languageCode;
  final int page;
  final int size;

  AllProductParams({
    required this.languageCode,
    required this.page,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      "lang": languageCode,
      "page": page.toString(),
      "size": size.toString(),
    };
  }
}

class ProductDataParams {
  final String languageCode;
  final String type;

  const ProductDataParams({required this.languageCode, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'lang': languageCode,
    };
  }
}

class AddProductParams {
  final String languageCode;

  const AddProductParams({required this.languageCode});

  Map<String, dynamic> toMap() {
    return {
      'lang': languageCode,
    };
  }
}

class EditProductParams {
  final String languageCode;
  final int id;

  const EditProductParams({required this.id, required this.languageCode});

  Map<String, dynamic> toMap() {
    return {
      'lang': languageCode,
    };
  }
}

class DeleteProductParams {
  final int id;

  const DeleteProductParams({required this.id});
}

class ProductNamesParams {
  final int id;
  String? type;

  ProductNamesParams({required this.id, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }
}

class SupplierParams {
  final int id;

  const SupplierParams({required this.id});
}

class SearchSupplierParams {
  final String keyword;

  const SearchSupplierParams({required this.keyword});
  Map<String, dynamic> toMap() {
    return {
      'name': keyword,
    };
  }
}

class DeletePurchaseOrderParams {
  final int id;

  const DeletePurchaseOrderParams({required this.id});
}

class DetailsPurchaseOrdersParams {
  final String languageCode;
  final int id;

  const DetailsPurchaseOrdersParams(
      {required this.id, required this.languageCode});

  Map<String, dynamic> toMap() {
    return {
      'language': languageCode,
    };
  }
}

class EditPurchaseOrdersParams {
  final String languageCode;
  final int id;

  const EditPurchaseOrdersParams(
      {required this.id, required this.languageCode});

  Map<String, dynamic> toMap() {
    return {
      'language': languageCode,
    };
  }
}

class PurchaseInvoiceDetailsParams {
  final String languageCode;
  final int id;

  const PurchaseInvoiceDetailsParams(
      {required this.id, required this.languageCode});

  Map<String, dynamic> toMap() {
    return {
      'language': languageCode,
    };
  }
}

class EditPurchaseInvoiceParams {
  final String languageCode;
  final int id;

  const EditPurchaseInvoiceParams(
      {required this.id, required this.languageCode});

  Map<String, dynamic> toMap() {
    return {
      'language': languageCode,
    };
  }
}

class SearchBySupplierParams {
  final int supplierId;
  final int page;
  final int size;
  final String language;

  const SearchBySupplierParams({
    required this.supplierId,
    required this.page,
    required this.size,
    required this.language,
  });
  Map<String, dynamic> toMap() {
    return {
      'page': page.toString(),
      'size': size.toString(),
      'language': language,
    };
  }
}

class SearchByDateRangeParams {
  final DateTime startDate;
  final DateTime endDate;
  final int page;
  final int size;
  final String language;

  const SearchByDateRangeParams({
    required this.startDate,
    required this.endDate,
    this.page = 0,
    this.size = 10,
    this.language = 'ar',
  });
  Map<String, dynamic> toMap() {
        dateFormat(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return {
      'startDate': dateFormat(startDate),
      'endDate': dateFormat(endDate),
      'page': page.toString(),
      'size': size.toString(),
      'language': language,
    };
  }
}

class LanguageParam {
  final String languageCode;
  final String key;

  const LanguageParam({
    required this.languageCode,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      key: languageCode,
    };
  }
}

class PaginationParams {
  final int page;
  final int size;
  final String languageCode;

  const PaginationParams({
    required this.page,
    required this.size,
    required this.languageCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page.toString(),
      'size': size.toString(),
      'language': languageCode,
    };
  }
}

class SaleProcessParams {
  final int? customerId;
  final String paymentType;
  final String paymentMethod;
  final String currency;
  final String discountType;
  final double discountValue;
  final double? paidAmount;
  final String? debtDueDate;
  final List<SaleItemParams> items;

  const SaleProcessParams({
    required this.customerId,
    required this.paymentType,
    required this.paymentMethod,
    required this.currency,
    required this.discountType,
    required this.discountValue,
    required this.paidAmount,
    required this.debtDueDate,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "paymentType": paymentType,
      "paymentMethod": paymentMethod,
      "currency": currency,
      "invoiceDiscountType": discountType,
      "invoiceDiscountValue": discountValue,
      "paidAmount": paidAmount,
      'debtDueDate': debtDueDate,
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}

class SaleItemParams {
  final int stockItemId;
  final int quantity;
  final double unitPrice;

  const SaleItemParams({
    required this.stockItemId,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      "stockItemId": stockItemId,
      "quantity": quantity,
      "unitPrice": unitPrice
    };
  }
}

class CustomerParams {
  final String name;
  final String phoneNumber;
  final String address;
  final String notes;

  CustomerParams(
      {required this.notes,
      required this.name,
      required this.phoneNumber,
      required this.address});
}

class SearchParams {
  final String name;
  const SearchParams({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

class SearchStockParams {
  final String keyword;
  final String lang;

  const SearchStockParams({required this.lang, required this.keyword});

  Map<String, dynamic> toMap() {
    return {'keyword': keyword, 'lang': lang};
  }
}

class ReconcileMoneyBoxParams {
  final double actualCashCount;
  final String notes;

  const ReconcileMoneyBoxParams(
      {required this.actualCashCount, required this.notes});

  Map<String, dynamic> toMap() {
    return {
      'actualCashCount': actualCashCount.toString(),
      'notes': notes,
    };
  }
}

class MoneyBoxTransactionParams {
  final double amount;
  final String description;

  const MoneyBoxTransactionParams(
      {required this.amount, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'amount': amount.toString(),
      'description': description,
    };
  }
}

class GetMoneyBoxTransactionParams {
  final int page;
  final int size;
  final DateTime? startDate; // اختياري
  final DateTime? endDate;   // اختياري
  final String? transactionType; // اختياري

  GetMoneyBoxTransactionParams({
    required this.page,
    required this.size,
    this.startDate,
    this.endDate,
    this.transactionType,
  });

  // // دالة لتحويل التاريخ للشكل المطلوب للـ API: YYYY-MM-DDTHH:MM:SS
  // String dateFormat(DateTime d) {
  //   final y = d.year.toString().padLeft(4, '0');
  //   final m = d.month.toString().padLeft(2, '0');
  //   final day = d.day.toString().padLeft(2, '0');
  //   final h = d.hour.toString().padLeft(2, '0');
  //   final min = d.minute.toString().padLeft(2, '0');
  //   final s = d.second.toString().padLeft(2, '0');
  //  return '$y-$m-$day' 'T$h:$min:$s';
  // }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> query = {
      'page': page.toString(),
      'size': size.toString(),
    };
        dateFormat(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    if (startDate != null) query['startDate'] = dateFormat(startDate!);
    if (endDate != null) query['endDate'] = dateFormat(endDate!);
    if (transactionType != null) query['transactionType'] = transactionType;

    return query;
  }
}



class SearchInvoiceByDateRangeParams {
  final DateTime startDate;
  final DateTime endDate;

  const SearchInvoiceByDateRangeParams({
    required this.startDate,
    required this.endDate,
  });
  Map<String, dynamic> toMap() {
    dateFormat(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    return {
      'startDate': dateFormat(startDate),
      'endDate': dateFormat(endDate),
    };
  }
}

class StockParams {
  final int id;
  final int quantity;
  final String expiryDate;
  final int minStockLevel;
  final String reasonCode;
  final String additionalNotes;

  StockParams({
    required this.id,
    required this.quantity,
    required this.expiryDate,
    required this.minStockLevel,
    required this.reasonCode,
    required this.additionalNotes,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "quantity": quantity,
      "expiryDate": expiryDate,
      "minStockLevel": minStockLevel,
      "reasonCode": reasonCode,
      "additionalNotes": additionalNotes,
    };
  }
}

class PaymentParams {
  final double totalPaymentAmount;
  final String paymentMethod;
  final String notes;

  PaymentParams({
    required this.totalPaymentAmount,
    required this.paymentMethod,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "totalPaymentAmount": totalPaymentAmount,
      "paymentMethod": paymentMethod,
      if (notes.isNotEmpty) "notes": notes, // اختياري
    };
  }
}

class RefundItemParams {
  final int itemId;
  final int quantity;
  final String itemRefundReason;

  RefundItemParams({
    required this.itemId,
    required this.quantity,
    required this.itemRefundReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
      'itemRefundReason': itemRefundReason,
    };
  }
}

class SaleRefundParams {
  final List<RefundItemParams> refundItems;
  final String refundReason;

  SaleRefundParams({
    required this.refundItems,
    required this.refundReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'refundItems': refundItems.map((e) => e.toJson()).toList(),
      'refundReason': refundReason,
    };
  }
}
