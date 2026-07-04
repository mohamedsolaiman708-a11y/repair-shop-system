import 'package:flutter_test/flutter_test.dart';
import 'package:repair_center_syste/features/repairs/domain/entities/repair_order.dart';

void main() {
  group('RepairStatus State Transition Rules', () {
    test('Self-transition is always valid', () {
      for (final status in RepairStatus.values) {
        expect(status.canTransitionTo(status), isTrue);
      }
    });

    test('Registered transitions', () {
      const status = RepairStatus.registered;
      expect(status.canTransitionTo(RepairStatus.underInspection), isTrue);
      
      // All other transitions should be invalid
      for (final other in RepairStatus.values) {
        if (other != RepairStatus.registered && other != RepairStatus.underInspection) {
          expect(status.canTransitionTo(other), isFalse, reason: 'Failed transition check: $status -> $other');
        }
      }
    });

    test('Under Inspection transitions', () {
      const status = RepairStatus.underInspection;
      expect(status.canTransitionTo(RepairStatus.waitingCustomerApproval), isTrue);
      expect(status.canTransitionTo(RepairStatus.repairInProgress), isTrue);
      expect(status.canTransitionTo(RepairStatus.notRepairable), isTrue);

      for (final other in RepairStatus.values) {
        if (other != RepairStatus.underInspection &&
            other != RepairStatus.waitingCustomerApproval &&
            other != RepairStatus.repairInProgress &&
            other != RepairStatus.notRepairable) {
          expect(status.canTransitionTo(other), isFalse, reason: 'Failed transition check: $status -> $other');
        }
      }
    });

    test('Waiting Customer Approval transitions', () {
      const status = RepairStatus.waitingCustomerApproval;
      expect(status.canTransitionTo(RepairStatus.repairInProgress), isTrue);
      expect(status.canTransitionTo(RepairStatus.cancelled), isTrue);

      for (final other in RepairStatus.values) {
        if (other != RepairStatus.waitingCustomerApproval &&
            other != RepairStatus.repairInProgress &&
            other != RepairStatus.cancelled) {
          expect(status.canTransitionTo(other), isFalse, reason: 'Failed transition check: $status -> $other');
        }
      }
    });

    test('Repair In Progress transitions', () {
      const status = RepairStatus.repairInProgress;
      expect(status.canTransitionTo(RepairStatus.waitingParts), isTrue);
      expect(status.canTransitionTo(RepairStatus.readyForPickup), isTrue);
      expect(status.canTransitionTo(RepairStatus.notRepairable), isTrue);

      for (final other in RepairStatus.values) {
        if (other != RepairStatus.repairInProgress &&
            other != RepairStatus.waitingParts &&
            other != RepairStatus.readyForPickup &&
            other != RepairStatus.notRepairable) {
          expect(status.canTransitionTo(other), isFalse, reason: 'Failed transition check: $status -> $other');
        }
      }
    });

    test('Waiting Parts transitions', () {
      const status = RepairStatus.waitingParts;
      expect(status.canTransitionTo(RepairStatus.repairInProgress), isTrue);

      for (final other in RepairStatus.values) {
        if (other != RepairStatus.waitingParts && other != RepairStatus.repairInProgress) {
          expect(status.canTransitionTo(other), isFalse, reason: 'Failed transition check: $status -> $other');
        }
      }
    });

    test('Ready For Pickup transitions', () {
      const status = RepairStatus.readyForPickup;
      expect(status.canTransitionTo(RepairStatus.delivered), isTrue);

      for (final other in RepairStatus.values) {
        if (other != RepairStatus.readyForPickup && other != RepairStatus.delivered) {
          expect(status.canTransitionTo(other), isFalse, reason: 'Failed transition check: $status -> $other');
        }
      }
    });

    test('Terminal states cannot transition to other states', () {
      const terminalStates = [RepairStatus.delivered, RepairStatus.cancelled];
      for (final status in terminalStates) {
        for (final other in RepairStatus.values) {
          if (other != status) {
            expect(status.canTransitionTo(other), isFalse, reason: 'Failed terminal transition check: $status -> $other');
          }
        }
      }
    });
  });
}
