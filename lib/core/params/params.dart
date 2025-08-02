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
  final List<String> daysOfWeek;
  final List<ShiftParams> shifts;

  const WorkingHoursRequestParams(
    this.daysOfWeek,
    this.shifts,
  );

  Map<String, dynamic> toJson() {
    return {
      'daysOfWeek': daysOfWeek,
      'shifts': shifts.map((shift) => shift.toJson()).toList(),
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
