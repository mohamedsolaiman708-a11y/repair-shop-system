class TechnicianEntity {
  final String id;
  final String branchId;
  final String name;
  final String phone;
  final String? specialization;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TechnicianEntity({
    required this.id,
    required this.branchId,
    required this.name,
    required this.phone,
    this.specialization,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}
