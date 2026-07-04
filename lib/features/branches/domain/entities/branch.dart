class BranchEntity {
  final String id;
  final String name;
  final String phone;
  final String address;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BranchEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
