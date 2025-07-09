class PharmacyEntity {
  final int? id;
  final String pharmacyName;
  final String licenseNumber;
  final String address;
  final String email;
  final String type;
  final String openingHours;
  final String phoneNumber;
  final String managerEmail;
  final String managerFirstName;
  final String managerLastName;
  final String newPassword;

  PharmacyEntity({
    this.id,
    required this.pharmacyName,
    required this.licenseNumber,
    required this.address,
    required this.email,
    required this.type,
    required this.openingHours,
    required this.phoneNumber,
    required this.managerEmail,
    required this.managerFirstName,
    required this.managerLastName,
    required this.newPassword,
  });
}
