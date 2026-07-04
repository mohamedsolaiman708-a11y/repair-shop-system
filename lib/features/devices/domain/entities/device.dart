class DeviceEntity {
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

  const DeviceEntity({
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
}
