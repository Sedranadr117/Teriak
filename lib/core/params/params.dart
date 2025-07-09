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
  final DateTime dateOfHire;
  final int roleId;
  final WorkTimeParams workStart;
  final WorkTimeParams workEnd;

  const EmployeeParams(
    this.firstName,
    this.lastName,
    this.password,
    this.phoneNumber,
    this.status,
    this.dateOfHire,
    this.roleId,
    this.workStart,
    this.workEnd,
  );
}

class WorkTimeParams {
  final int hour;
  final int minute;
  final int second;
  final int nano;

  const WorkTimeParams(
    this.hour,
    this.minute,
    this.second,
    this.nano,
  );
}

enum AuthType {
  mangerLogin,
  logout,
}
