class EmployeeEntity {
  final String firstName;
  final String lastName;
  final String password;
  final String phoneNumber;
  final String status;
  final DateTime dateOfHire;
  final int roleId;
  final WorkTimeEntity workStart;
  final WorkTimeEntity workEnd;

  const EmployeeEntity({
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
}

class WorkTimeEntity {
  final int hour;
  final int minute;
  final int second;
  final int nano;

  const WorkTimeEntity({
    required this.hour,
    required this.minute,
    required this.second,
    required this.nano,
  });
}
