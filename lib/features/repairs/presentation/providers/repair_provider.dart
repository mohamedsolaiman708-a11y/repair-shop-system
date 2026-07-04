import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/repair_repository_impl.dart';
import '../../domain/entities/repair_order.dart';
import '../../domain/repositories/repair_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final repairRepositoryProvider = Provider<RepairRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RepairRepositoryImpl(client);
});

final repairOrdersListProvider = FutureProvider.family.autoDispose<List<RepairOrderEntity>, ({String? status, String? query})>((ref, filter) async {
  final repo = ref.watch(repairRepositoryProvider);
  final result = await repo.getRepairOrders(status: filter.status, query: filter.query);
  return result.fold(
    (list) => list,
    (failure) => throw Exception(failure.message),
  );
});

final repairOrderDetailsProvider = FutureProvider.family.autoDispose<RepairOrderEntity, String>((ref, id) async {
  final repo = ref.watch(repairRepositoryProvider);
  final result = await repo.getRepairOrderById(id);
  return result.fold(
    (order) => order,
    (failure) => throw Exception(failure.message),
  );
});

final repairStatusHistoryProvider = FutureProvider.family.autoDispose<List<Map<String, dynamic>>, String>((ref, id) async {
  final repo = ref.watch(repairRepositoryProvider);
  final result = await repo.getStatusHistory(id);
  return result.fold(
    (list) => list,
    (failure) => throw Exception(failure.message),
  );
});

class RepairOrderNotifier extends AutoDisposeAsyncNotifier<RepairOrderEntity?> {
  late final RepairRepository _repository;

  @override
  FutureOr<RepairOrderEntity?> build() {
    _repository = ref.watch(repairRepositoryProvider);
    return null;
  }

  Future<RepairOrderEntity?> create(RepairOrderEntity repair) async {
    state = const AsyncValue.loading();
    final result = await _repository.createRepairOrder(repair);
    return result.fold(
      (newRepair) {
        state = AsyncValue.data(newRepair);
        return newRepair;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }

  Future<RepairOrderEntity?> updateStatus(RepairOrderEntity repair, RepairStatus nextStatus, {String? notes}) async {
    if (!repair.status.canTransitionTo(nextStatus)) {
      state = AsyncValue.error(
        Exception('Invalid status transition from ${repair.status.label} to ${nextStatus.label}'),
        StackTrace.current,
      );
      return null;
    }

    state = const AsyncValue.loading();
    DateTime? completedAt = repair.completedAt;
    DateTime? deliveredAt = repair.deliveredAt;

    if (nextStatus == RepairStatus.readyForPickup) {
      completedAt = DateTime.now().toUtc();
    } else if (nextStatus == RepairStatus.delivered) {
      deliveredAt = DateTime.now().toUtc();
    }

    final updatedEntity = RepairOrderEntity(
      id: repair.id,
      branchId: repair.branchId,
      deviceId: repair.deviceId,
      technicianId: repair.technicianId,
      repairNumber: repair.repairNumber,
      barcode: repair.barcode,
      status: nextStatus,
      problemDescription: repair.problemDescription,
      inspectionNotes: notes ?? repair.inspectionNotes,
      repairNotes: repair.repairNotes,
      estimatedCost: repair.estimatedCost,
      finalCost: repair.finalCost,
      deposit: repair.deposit,
      deliveryDate: repair.deliveryDate,
      completedAt: completedAt,
      deliveredAt: deliveredAt,
      createdBy: repair.createdBy,
      createdAt: repair.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );

    final result = await _repository.updateRepairOrder(updatedEntity);
    return result.fold(
      (updated) {
        state = AsyncValue.data(updated);
        ref.invalidate(repairOrdersListProvider);
        ref.invalidate(repairOrderDetailsProvider(repair.id));
        ref.invalidate(repairStatusHistoryProvider(repair.id));
        return updated;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }
}

final repairOrderNotifierProvider = AutoDisposeAsyncNotifierProvider<RepairOrderNotifier, RepairOrderEntity?>(() {
  return RepairOrderNotifier();
});
