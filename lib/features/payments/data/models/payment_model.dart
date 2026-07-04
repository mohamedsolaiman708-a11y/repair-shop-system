import '../../domain/entities/payment.dart';

class PaymentModel {
  final String id;
  final String repairOrderId;
  final double amount;
  final String paymentMethod;
  final String paymentType;
  final String? notes;
  final String? createdBy;
  final DateTime createdAt;

  const PaymentModel({
    required this.id,
    required this.repairOrderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentType,
    this.notes,
    this.createdBy,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      repairOrderId: json['repair_order_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      paymentType: json['payment_type'] as String,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'repair_order_id': repairOrderId,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_type': paymentType,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory PaymentModel.fromEntity(PaymentEntity entity) => PaymentModel(
        id: entity.id,
        repairOrderId: entity.repairOrderId,
        amount: entity.amount,
        paymentMethod: entity.paymentMethod.label,
        paymentType: entity.paymentType.label,
        notes: entity.notes,
        createdBy: entity.createdBy,
        createdAt: entity.createdAt,
      );

  PaymentEntity toEntity() => PaymentEntity(
        id: id,
        repairOrderId: repairOrderId,
        amount: amount,
        paymentMethod: PaymentMethod.fromString(paymentMethod),
        paymentType: PaymentType.fromString(paymentType),
        notes: notes,
        createdBy: createdBy,
        createdAt: createdAt,
      );

  PaymentModel copyWith({
    String? id,
    String? repairOrderId,
    double? amount,
    String? paymentMethod,
    String? paymentType,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentType: paymentType ?? this.paymentType,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
