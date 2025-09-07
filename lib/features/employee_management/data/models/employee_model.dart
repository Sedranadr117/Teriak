import '../../domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  EmployeeModel({
    required int id,
    required String firstName,
    required String lastName,
    required String password,
    required String phoneNumber,
    required String status,
    required String roleName,
    required String email,
    required String dateOfHire,
    required int roleId,
    required List<WorkingHoursRequestModel> workingHoursRequests,
  }) : super(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          password: password,
          phoneNumber: phoneNumber,
          status: status,
          roleName: roleName,
          dateOfHire: dateOfHire,
          roleId: roleId,
          workingHoursRequests: workingHoursRequests,
        );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? '',
      roleName: json['roleName'] ?? '',
      dateOfHire: json['dateOfHire'] ?? '',
      roleId: json['roleId'] ?? 0,
      workingHoursRequests: List.from(
              json['workingHoursRequests'] ?? json['workingHours'] ?? [])
          .map<WorkingHoursRequestModel>((e) => e is WorkingHoursRequestModel
              ? e
              : WorkingHoursRequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'phoneNumber': phoneNumber,
      'status': status,
      'email': email,
      'dateOfHire': dateOfHire,
      'roleId': roleId,
      'workingHoursRequests':
          (workingHoursRequests as List<WorkingHoursRequestModel>)
              .map((e) => e.toJson())
              .toList()
    };
  }
}

class WorkingHoursRequestModel extends WorkingHoursRequestEntity {
  WorkingHoursRequestModel({
    required List<String> daysOfWeek,
    required List<ShiftModel> shifts,
  }) : super(
          daysOfWeek: daysOfWeek,
          shifts: shifts,
        );

  factory WorkingHoursRequestModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursRequestModel(
      daysOfWeek: List<String>.from(json['daysOfWeek'] ?? []),
      shifts: List.from(json['shifts'] ?? [])
          .map((e) => ShiftModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daysOfWeek': daysOfWeek,
      'shifts': (shifts as List<ShiftModel>).map((e) => e.toJson()).toList(),
    };
  }
}

class ShiftModel extends ShiftEntity {
  ShiftModel({
    required String startTime,
    required String endTime,
    required String description,
  }) : super(
          startTime: startTime,
          endTime: endTime,
          description: description,
        );

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
    };
  }
}
