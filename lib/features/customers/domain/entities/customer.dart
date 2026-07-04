class CustomerEntity {
  final String id;
  final String branchId;
  final String name;
  final String phone;
  final String? alternatePhone;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomerEntity({
    required this.id,
    required this.branchId,
    required this.name,
    required this.phone,
    this.alternatePhone,
    this.address,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
}
