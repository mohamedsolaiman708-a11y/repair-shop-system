import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/technician.dart';
import '../../domain/repositories/technician_repository.dart';
import '../models/technician_model.dart';

class TechnicianRepositoryImpl implements TechnicianRepository {
  final supabase.SupabaseClient _client;

  TechnicianRepositoryImpl(this._client);

  @override
  Future<Result<List<TechnicianEntity>, Failure>> getTechniciansByBranch(String branchId) async {
    try {
      final response = await _client.from('technicians').select().eq('branch_id', branchId);
      final list = (response as List)
          .map((json) => TechnicianModel.fromJson(json).toEntity())
          .toList();
      return Result.success(list);
    } catch (e, stack) {
      Log.e('Get technicians by branch failure: $branchId', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<TechnicianEntity, Failure>> createTechnician(TechnicianEntity technician) async {
    try {
      final model = TechnicianModel.fromEntity(technician);
      final response = await _client.from('technicians').insert(model.toJson()).select().single();
      return Result.success(TechnicianModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Create technician failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<TechnicianEntity, Failure>> updateTechnician(TechnicianEntity technician) async {
    try {
      final model = TechnicianModel.fromEntity(technician);
      final response = await _client
          .from('technicians')
          .update(model.toJson())
          .eq('id', technician.id)
          .select()
          .single();
      return Result.success(TechnicianModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Update technician failure for ID: ${technician.id}', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }
}
