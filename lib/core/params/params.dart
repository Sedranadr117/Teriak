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

  PhaParams(
      this.newPassword,
      this.location,
      this.managerFirstName,
      this.managerLastName,
      this.pharmacyPhone,
      this.pharmacyEmail,
      this.openingHours);
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

class WorkingHoursRequestParams {
  final List<ShiftParams> shifts;

  const WorkingHoursRequestParams(
    this.shifts,
  );

  Map<String, dynamic> toJson() {
    return {
      'shifts': shifts.map((shift) => shift.toJson()).toList(),
    };
  }
}

class ShiftParams {
  final String startTime;
  final String endTime;
  final String description;
  final List<String> daysOfWeek;

  const ShiftParams(
    this.startTime,
    this.endTime,
    this.description,
    this.daysOfWeek,
  );
  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
      'daysOfWeek': daysOfWeek
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

  const SearchProductParams(
      {required this.keyword, required this.languageCode});

  Map<String, dynamic> toMap() {
    return {
      'keyword': keyword,
      'languageCode': languageCode,
    };
  }
}

class AllProductParams {
  final String languageCode;

  const AllProductParams({required this.languageCode});

  Map<String, dynamic> toMap() {
    return {
      'languageCode': languageCode,
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

class SaleProcessParams {
  final int customerId;
  final String paymentType;
  final String paymentMethod;
  final String currency;
  final String discountType;
  final double discountValue;
  final double? paidAmount;
  final List<SaleItemParams> items;

  const SaleProcessParams({
    required this.customerId,
    required this.paymentType,
    required this.paymentMethod,
    required this.currency,
    required this.discountType,
    required this.discountValue,
    this.paidAmount,
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
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
}

class SaleItemParams {
  final int stockItemId;
  final int quantity;
  final double unitPrice;
  final double discountValue;
  final String discountType;

  const SaleItemParams({
    required this.stockItemId,
    required this.quantity,
    required this.unitPrice,
    required this.discountType,
    required this.discountValue,
  });

  Map<String, dynamic> toJson() {
    return {
      "stockItemId": stockItemId,
      "quantity": quantity,
      "unitPrice": unitPrice,
      "discountValue": discountValue,
      "discountType": discountType,
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

class StockParams {
  int id;
  StockParams({
    required this.id,
  });
}
