enum PaymentMethod {
  cash('Cash'),
  card('Card'),
  bankTransfer('Bank Transfer'),
  mobileWallet('Mobile Wallet');

  final String label;
  const PaymentMethod(this.label);

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase() || e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PaymentMethod.cash,
    );
  }
}

enum PaymentType {
  deposit('Deposit'),
  partial('Partial'),
  full('Full');

  final String label;
  const PaymentType(this.label);

  static PaymentType fromString(String value) {
    return PaymentType.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase() || e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => PaymentType.partial,
    );
  }
}

class PaymentEntity {
  final String id;
  final String repairOrderId;
  final double amount;
  final PaymentMethod paymentMethod;
  final PaymentType paymentType;
  final String? notes;
  final String? createdBy;
  final DateTime createdAt;

  const PaymentEntity({
    required this.id,
    required this.repairOrderId,
    required this.amount,
    required this.paymentMethod,
    required this.paymentType,
    this.notes,
    this.createdBy,
    required this.createdAt,
  });
}
