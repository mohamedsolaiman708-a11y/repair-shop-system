import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/branch.dart';
import '../../domain/repositories/branch_repository.dart';
import '../models/branch_model.dart';

class BranchRepositoryImpl implements BranchRepository {
  final supabase.SupabaseClient _client;

  BranchRepositoryImpl(this._client);

  @override
  Future<Result<List<BranchEntity>, Failure>> getBranches() async {
    try {
      final response = await _client.from('branches').select();
      final list = (response as List)
          .map((json) => BranchModel.fromJson(json).toEntity())
          .toList();
      return Result.success(list);
    } catch (e, stack) {
      Log.e('Get branches failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<BranchEntity, Failure>> getBranch(String id) async {
    try {
      final response = await _client.from('branches').select().eq('id', id).single();
      return Result.success(BranchModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Get branch failure for ID: $id', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<BranchEntity, Failure>> createBranch(BranchEntity branch) async {
    try {
      final model = BranchModel.fromEntity(branch);
      final response = await _client.from('branches').insert(model.toJson()).select().single();
      return Result.success(BranchModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Create branch failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<BranchEntity, Failure>> updateBranch(BranchEntity branch) async {
    try {
      final model = BranchModel.fromEntity(branch);
      final response = await _client
          .from('branches')
          .update(model.toJson())
          .eq('id', branch.id)
          .select()
          .single();
      return Result.success(BranchModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Update branch failure for ID: ${branch.id}', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }
}
