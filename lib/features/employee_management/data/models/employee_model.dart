class EmployeeModel {
  final String firstName;
  final String lastName;
  final String password;
  final String phoneNumber;
  final String status;
  final DateTime dateOfHire;
  final int roleId;
  final WorkTime workStart;
  final WorkTime workEnd;

  EmployeeModel({
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
    required this.status,
    required this.dateOfHire,
    required this.roleId,
    required this.workStart,
    required this.workEnd,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      status: json['status'],
      dateOfHire: DateTime.parse(json['dateOfHire']),
      roleId: json['roleId'],
      workStart: WorkTime.fromJson(json['workStart']),
      workEnd: WorkTime.fromJson(json['workEnd']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'phoneNumber': phoneNumber,
      'status': status,
      'dateOfHire': dateOfHire.toIso8601String(),
      'roleId': roleId,
      'workStart': workStart.toJson(),
      'workEnd': workEnd.toJson(),
    };
  }
}

class WorkTime {
  final int hour;
  final int minute;
  final int second;
  final int nano;

  WorkTime({
    required this.hour,
    required this.minute,
    required this.second,
    required this.nano,
  });

  factory WorkTime.fromJson(Map<String, dynamic> json) {
    return WorkTime(
      hour: json['hour'],
      minute: json['minute'],
      second: json['second'],
      nano: json['nano'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
      'second': second,
      'nano': nano,
    };
  }
}
