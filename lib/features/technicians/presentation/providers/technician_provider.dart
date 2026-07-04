import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/technician_repository_impl.dart';
import '../../domain/entities/technician.dart';
import '../../domain/repositories/technician_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final technicianRepositoryProvider = Provider<TechnicianRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TechnicianRepositoryImpl(client);
});

final branchTechniciansProvider = FutureProvider.family.autoDispose<List<TechnicianEntity>, String>((ref, branchId) async {
  if (branchId.isEmpty) return const [];
  final repo = ref.watch(technicianRepositoryProvider);
  final result = await repo.getTechniciansByBranch(branchId);
  return result.fold(
    (list) => list,
    (failure) => throw Exception(failure.message),
  );
});

class TechnicianNotifier extends AutoDisposeAsyncNotifier<TechnicianEntity?> {
  late final TechnicianRepository _repository;

  @override
  FutureOr<TechnicianEntity?> build() {
    _repository = ref.watch(technicianRepositoryProvider);
    return null;
  }

  Future<TechnicianEntity?> create(TechnicianEntity technician) async {
    state = const AsyncValue.loading();
    final result = await _repository.createTechnician(technician);
    return result.fold(
      (newTech) {
        state = AsyncValue.data(newTech);
        return newTech;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }

  Future<TechnicianEntity?> updateTechnician(TechnicianEntity technician) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateTechnician(technician);
    return result.fold(
      (updatedTech) {
        state = AsyncValue.data(updatedTech);
        return updatedTech;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }
}

final technicianNotifierProvider = AutoDisposeAsyncNotifierProvider<TechnicianNotifier, TechnicianEntity?>(() {
  return TechnicianNotifier();
});
