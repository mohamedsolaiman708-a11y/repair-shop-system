import '../../domain/entities/repair_order.dart';

class RepairOrderModel {
  final String id;
  final String branchId;
  final String deviceId;
  final String? technicianId;
  final String repairNumber;
  final String barcode;
  final String status;
  final String problemDescription;
  final String? inspectionNotes;
  final String? repairNotes;
  final double? estimatedCost;
  final double? finalCost;
  final double deposit;
  final DateTime? deliveryDate;
  final DateTime? completedAt;
  final DateTime? deliveredAt;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RepairOrderModel({
    required this.id,
    required this.branchId,
    required this.deviceId,
    this.technicianId,
    required this.repairNumber,
    required this.barcode,
    required this.status,
    required this.problemDescription,
    this.inspectionNotes,
    this.repairNotes,
    this.estimatedCost,
    this.finalCost,
    required this.deposit,
    this.deliveryDate,
    this.completedAt,
    this.deliveredAt,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RepairOrderModel.fromJson(Map<String, dynamic> json) {
    return RepairOrderModel(
      id: json['id'] as String,
      branchId: json['branch_id'] as String,
      deviceId: json['device_id'] as String,
      technicianId: json['technician_id'] as String?,
      repairNumber: json['repair_number'] as String,
      barcode: json['barcode'] as String,
      status: json['status'] as String,
      problemDescription: json['problem_description'] as String,
      inspectionNotes: json['inspection_notes'] as String?,
      repairNotes: json['repair_notes'] as String?,
      estimatedCost: json['estimated_cost'] != null ? (json['estimated_cost'] as num).toDouble() : null,
      finalCost: json['final_cost'] != null ? (json['final_cost'] as num).toDouble() : null,
      deposit: (json['deposit'] as num).toDouble(),
      deliveryDate: json['delivery_date'] != null ? DateTime.parse(json['delivery_date'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      deliveredAt: json['delivered_at'] != null ? DateTime.parse(json['delivered_at'] as String) : null,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'device_id': deviceId,
      'technician_id': technicianId,
      'repair_number': repairNumber,
      'barcode': barcode,
      'status': status,
      'problem_description': problemDescription,
      'inspection_notes': inspectionNotes,
      'repair_notes': repairNotes,
      'estimated_cost': estimatedCost,
      'final_cost': finalCost,
      'deposit': deposit,
      'delivery_date': deliveryDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory RepairOrderModel.fromEntity(RepairOrderEntity entity) => RepairOrderModel(
        id: entity.id,
        branchId: entity.branchId,
        deviceId: entity.deviceId,
        technicianId: entity.technicianId,
        repairNumber: entity.repairNumber,
        barcode: entity.barcode,
        status: entity.status.name,
        problemDescription: entity.problemDescription,
        inspectionNotes: entity.inspectionNotes,
        repairNotes: entity.repairNotes,
        estimatedCost: entity.estimatedCost,
        finalCost: entity.finalCost,
        deposit: entity.deposit,
        deliveryDate: entity.deliveryDate,
        completedAt: entity.completedAt,
        deliveredAt: entity.deliveredAt,
        createdBy: entity.createdBy,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  RepairOrderEntity toEntity() => RepairOrderEntity(
        id: id,
        branchId: branchId,
        deviceId: deviceId,
        technicianId: technicianId,
        repairNumber: repairNumber,
        barcode: barcode,
        status: RepairStatus.fromString(status),
        problemDescription: problemDescription,
        inspectionNotes: inspectionNotes,
        repairNotes: repairNotes,
        estimatedCost: estimatedCost,
        finalCost: finalCost,
        deposit: deposit,
        deliveryDate: deliveryDate,
        completedAt: completedAt,
        deliveredAt: deliveredAt,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  RepairOrderModel copyWith({
    String? id,
    String? branchId,
    String? deviceId,
    String? technicianId,
    String? repairNumber,
    String? barcode,
    String? status,
    String? problemDescription,
    String? inspectionNotes,
    String? repairNotes,
    double? estimatedCost,
    double? finalCost,
    double? deposit,
    DateTime? deliveryDate,
    DateTime? completedAt,
    DateTime? deliveredAt,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RepairOrderModel(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      deviceId: deviceId ?? this.deviceId,
      technicianId: technicianId ?? this.technicianId,
      repairNumber: repairNumber ?? this.repairNumber,
      barcode: barcode ?? this.barcode,
      status: status ?? this.status,
      problemDescription: problemDescription ?? this.problemDescription,
      inspectionNotes: inspectionNotes ?? this.inspectionNotes,
      repairNotes: repairNotes ?? this.repairNotes,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      finalCost: finalCost ?? this.finalCost,
      deposit: deposit ?? this.deposit,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      completedAt: completedAt ?? this.completedAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
