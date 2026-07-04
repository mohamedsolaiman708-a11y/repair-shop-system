import '../../domain/entities/customer.dart';

class CustomerModel {
  final String id;
  final String branchId;
  final String name;
  final String phone;
  final String? alternatePhone;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomerModel({
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

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      alternatePhone: json['alternate_phone'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
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
      'alternate_phone': alternatePhone,
      'address': address,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory CustomerModel.fromEntity(CustomerEntity entity) => CustomerModel(
        id: entity.id,
        branchId: entity.branchId,
        name: entity.name,
        phone: entity.phone,
        alternatePhone: entity.alternatePhone,
        address: entity.address,
        notes: entity.notes,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  CustomerEntity toEntity() => CustomerEntity(
        id: id,
        branchId: branchId,
        name: name,
        phone: phone,
        alternatePhone: alternatePhone,
        address: address,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  CustomerModel copyWith({
    String? id,
    String? branchId,
    String? name,
    String? phone,
    String? alternatePhone,
    String? address,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
