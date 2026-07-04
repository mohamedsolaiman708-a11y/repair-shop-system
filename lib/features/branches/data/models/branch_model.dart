import '../../domain/entities/branch.dart';

class BranchModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BranchModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BranchModel.fromEntity(BranchEntity entity) => BranchModel(
        id: entity.id,
        name: entity.name,
        phone: entity.phone,
        address: entity.address,
        isActive: entity.isActive,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  BranchEntity toEntity() => BranchEntity(
        id: id,
        name: name,
        phone: phone,
        address: address,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  BranchModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
