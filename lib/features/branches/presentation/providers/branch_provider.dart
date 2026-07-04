import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/branch_repository_impl.dart';
import '../../domain/entities/branch.dart';
import '../../domain/repositories/branch_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return BranchRepositoryImpl(client);
});

class BranchesNotifier extends AsyncNotifier<List<BranchEntity>> {
  late final BranchRepository _repository;

  @override
  FutureOr<List<BranchEntity>> build() async {
    _repository = ref.watch(branchRepositoryProvider);
    final result = await _repository.getBranches();
    return result.fold(
      (list) => list,
      (failure) => throw Exception(failure.message),
    );
  }

  Future<void> addBranch(BranchEntity branch) async {
    state = const AsyncValue.loading();
    final result = await _repository.createBranch(branch);
    result.fold(
      (newBranch) {
        final current = state.value ?? [];
        state = AsyncValue.data([...current, newBranch]);
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  Future<void> editBranch(BranchEntity branch) async {
    state = const AsyncValue.loading();
    final result = await _repository.updateBranch(branch);
    result.fold(
      (updatedBranch) {
        final current = state.value ?? [];
        state = AsyncValue.data(
          current.map((b) => b.id == updatedBranch.id ? updatedBranch : b).toList(),
        );
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }
}

final branchesListProvider = AsyncNotifierProvider<BranchesNotifier, List<BranchEntity>>(() {
  return BranchesNotifier();
});
