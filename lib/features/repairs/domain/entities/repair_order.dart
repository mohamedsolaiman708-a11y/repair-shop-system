enum RepairStatus {
  registered('Registered'),
  underInspection('Under Inspection'),
  waitingCustomerApproval('Waiting Customer Approval'),
  repairInProgress('Repair In Progress'),
  waitingParts('Waiting Parts'),
  readyForPickup('Ready For Pickup'),
  delivered('Delivered'),
  cancelled('Cancelled'),
  notRepairable('Not Repairable');

  final String label;
  const RepairStatus(this.label);

  static RepairStatus fromString(String value) {
    return RepairStatus.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase() || e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => RepairStatus.registered,
    );
  }

  /// Returns whether a transition to [nextStatus] is valid according to business rules.
  bool canTransitionTo(RepairStatus nextStatus) {
    if (this == nextStatus) return true; // Transitioning to self is always allowed
    
    switch (this) {
      case RepairStatus.registered:
        return nextStatus == RepairStatus.underInspection;
      case RepairStatus.underInspection:
        return nextStatus == RepairStatus.waitingCustomerApproval ||
            nextStatus == RepairStatus.repairInProgress ||
            nextStatus == RepairStatus.notRepairable;
      case RepairStatus.waitingCustomerApproval:
        return nextStatus == RepairStatus.repairInProgress || 
            nextStatus == RepairStatus.cancelled;
      case RepairStatus.repairInProgress:
        return nextStatus == RepairStatus.waitingParts ||
            nextStatus == RepairStatus.readyForPickup ||
            nextStatus == RepairStatus.notRepairable;
      case RepairStatus.waitingParts:
        return nextStatus == RepairStatus.repairInProgress;
      case RepairStatus.readyForPickup:
        return nextStatus == RepairStatus.delivered;
      case RepairStatus.notRepairable:
        return nextStatus == RepairStatus.delivered;
      case RepairStatus.delivered:
      case RepairStatus.cancelled:
        return false; // Terminal states, closed repair order
    }
  }
}

class RepairOrderEntity {
  final String id;
  final String branchId;
  final String deviceId;
  final String? technicianId;
  final String repairNumber;
  final String barcode;
  final RepairStatus status;
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

  const RepairOrderEntity({
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

  bool get isClosed => status == RepairStatus.delivered || status == RepairStatus.cancelled;
}
