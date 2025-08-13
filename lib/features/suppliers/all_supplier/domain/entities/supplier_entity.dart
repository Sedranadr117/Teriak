class SupplierEntity {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String preferredCurrency;

  const SupplierEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.preferredCurrency,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SupplierEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
