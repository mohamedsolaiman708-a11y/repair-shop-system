import '../../domain/entities/whatsapp_log.dart';

class WhatsAppLogModel {
  final String id;
  final String repairOrderId;
  final String templateName;
  final String phone;
  final String status;
  final String? response;
  final DateTime sentAt;

  const WhatsAppLogModel({
    required this.id,
    required this.repairOrderId,
    required this.templateName,
    required this.phone,
    required this.status,
    this.response,
    required this.sentAt,
  });

  factory WhatsAppLogModel.fromJson(Map<String, dynamic> json) {
    return WhatsAppLogModel(
      id: json['id'] as String,
      repairOrderId: json['repair_order_id'] as String,
      templateName: json['template_name'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
      response: json['response'] as String?,
      sentAt: DateTime.parse(json['sent_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'repair_order_id': repairOrderId,
      'template_name': templateName,
      'phone': phone,
      'status': status,
      'response': response,
      'sent_at': sentAt.toIso8601String(),
    };
  }

  factory WhatsAppLogModel.fromEntity(WhatsAppLogEntity entity) => WhatsAppLogModel(
        id: entity.id,
        repairOrderId: entity.repairOrderId,
        templateName: entity.templateName,
        phone: entity.phone,
        status: entity.status.label,
        response: entity.response,
        sentAt: entity.sentAt,
      );

  WhatsAppLogEntity toEntity() => WhatsAppLogEntity(
        id: id,
        repairOrderId: repairOrderId,
        templateName: templateName,
        phone: phone,
        status: WhatsAppStatus.fromString(status),
        response: response,
        sentAt: sentAt,
      );

  WhatsAppLogModel copyWith({
    String? id,
    String? repairOrderId,
    String? templateName,
    String? phone,
    String? status,
    String? response,
    DateTime? sentAt,
  }) {
    return WhatsAppLogModel(
      id: id ?? this.id,
      repairOrderId: repairOrderId ?? this.repairOrderId,
      templateName: templateName ?? this.templateName,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      response: response ?? this.response,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}
