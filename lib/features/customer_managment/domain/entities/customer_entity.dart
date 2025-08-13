class CustomerEntity {
  final int id;
  final String name;
  final String phoneNumber;
  final String address;
  final String notes;

  CustomerEntity({
    required this.id,
    required this.name,
    this.phoneNumber = '',
    this.address = '',
    this.notes = '',
  });
}
