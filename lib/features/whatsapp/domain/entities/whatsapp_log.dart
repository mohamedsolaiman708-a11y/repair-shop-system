enum WhatsAppStatus {
  pending('Pending'),
  sent('Sent'),
  failed('Failed');

  final String label;
  const WhatsAppStatus(this.label);

  static WhatsAppStatus fromString(String value) {
    return WhatsAppStatus.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase() || e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => WhatsAppStatus.pending,
    );
  }
}

class WhatsAppLogEntity {
  final String id;
  final String repairOrderId;
  final String templateName;
  final String phone;
  final WhatsAppStatus status;
  final String? response;
  final DateTime sentAt;

  const WhatsAppLogEntity({
    required this.id,
    required this.repairOrderId,
    required this.templateName,
    required this.phone,
    required this.status,
    this.response,
    required this.sentAt,
  });
}
