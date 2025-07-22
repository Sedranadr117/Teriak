class EmployeeEntity {
  final int id;
  final String? firstName;
  final String? lastName;
  final String password;
  final String phoneNumber;
  final String status;
  final String roleName;
  final String dateOfHire;
  final int roleId;
  final List<WorkingHoursRequestEntity> workingHoursRequests;

  const EmployeeEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
    required this.status,
    required this.roleName,
    required this.dateOfHire,
    required this.roleId,
    required this.workingHoursRequests,
  });
}

class WorkingHoursRequestEntity {
  final List<String> daysOfWeek;
  final List<ShiftEntity> shifts;

  const WorkingHoursRequestEntity({
    required this.daysOfWeek,
    required this.shifts,
  });
}

class ShiftEntity {
  final String startTime;
  final String endTime;
  final String description;

  const ShiftEntity({
    required this.startTime,
    required this.endTime,
    required this.description,
  });
}
