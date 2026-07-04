import '../../domain/entities/device.dart';

class DeviceModel {
  final String id;
  final String customerId;
  final String deviceType;
  final String brand;
  final String model;
  final String? serialNumber;
  final String? color;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeviceModel({
    required this.id,
    required this.customerId,
    required this.deviceType,
    required this.brand,
    required this.model,
    this.serialNumber,
    this.color,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      deviceType: json['device_type'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      serialNumber: json['serial_number'] as String?,
      color: json['color'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'device_type': deviceType,
      'brand': brand,
      'model': model,
      'serial_number': serialNumber,
      'color': color,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DeviceModel.fromEntity(DeviceEntity entity) => DeviceModel(
        id: entity.id,
        customerId: entity.customerId,
        deviceType: entity.deviceType,
        brand: entity.brand,
        model: entity.model,
        serialNumber: entity.serialNumber,
        color: entity.color,
        notes: entity.notes,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  DeviceEntity toEntity() => DeviceEntity(
        id: id,
        customerId: customerId,
        deviceType: deviceType,
        brand: brand,
        model: model,
        serialNumber: serialNumber,
        color: color,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  DeviceModel copyWith({
    String? id,
    String? customerId,
    String? deviceType,
    String? brand,
    String? model,
    String? serialNumber,
    String? color,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      deviceType: deviceType ?? this.deviceType,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      color: color ?? this.color,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
