import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String? branchId;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    this.branchId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String?,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        branchId: entity.branchId,
        fullName: entity.fullName,
        email: entity.email,
        phone: entity.phone,
        role: entity.role.name,
        isActive: entity.isActive,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  UserEntity toEntity() => UserEntity(
        id: id,
        branchId: branchId,
        fullName: fullName,
        email: email,
        phone: phone,
        role: UserRole.fromString(role),
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  UserModel copyWith({
    String? id,
    String? branchId,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
