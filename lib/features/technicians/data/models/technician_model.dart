import '../../domain/entities/technician.dart';

class TechnicianModel {
  final String id;
  final String branchId;
  final String name;
  final String phone;
  final String? specialization;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TechnicianModel({
    required this.id,
    required this.branchId,
    required this.name,
    required this.phone,
    this.specialization,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      specialization: json['specialization'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'name': name,
      'phone': phone,
      'specialization': specialization,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory TechnicianModel.fromEntity(TechnicianEntity entity) => TechnicianModel(
        id: entity.id,
        branchId: entity.branchId,
        name: entity.name,
        phone: entity.phone,
        specialization: entity.specialization,
        isActive: entity.isActive,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  TechnicianEntity toEntity() => TechnicianEntity(
        id: id,
        branchId: branchId,
        name: name,
        phone: phone,
        specialization: specialization,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  TechnicianModel copyWith({
    String? id,
    String? branchId,
    String? name,
    String? phone,
    String? specialization,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TechnicianModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      specialization: specialization ?? this.specialization,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
