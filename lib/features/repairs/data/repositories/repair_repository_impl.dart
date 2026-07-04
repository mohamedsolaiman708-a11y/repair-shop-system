import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/repair_order.dart';
import '../../domain/repositories/repair_repository.dart';
import '../models/repair_order_model.dart';

class RepairRepositoryImpl implements RepairRepository {
  final supabase.SupabaseClient _client;

  RepairRepositoryImpl(this._client);

  @override
  Future<Result<List<RepairOrderEntity>, Failure>> getRepairOrders({String? status, String? query}) async {
    try {
      var dbQuery = _client.from('repair_orders').select();

      if (status != null && status.isNotEmpty) {
        dbQuery = dbQuery.eq('status', status);
      }

      if (query != null && query.trim().isNotEmpty) {
        dbQuery = dbQuery.or('repair_number.ilike.%$query%,barcode.ilike.%$query%');
      }

      final response = await dbQuery.order('created_at', ascending: false);
      final list = (response as List)
          .map((json) => RepairOrderModel.fromJson(json).toEntity())
          .toList();

      return Result.success(list);
    } catch (e, stack) {
      Log.e('Get repair orders failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<RepairOrderEntity, Failure>> getRepairOrderById(String id) async {
    try {
      final response = await _client.from('repair_orders').select().eq('id', id).single();
      return Result.success(RepairOrderModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Get repair order by ID failure: $id', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<RepairOrderEntity, Failure>> getRepairOrderByBarcode(String barcode) async {
    try {
      final response = await _client.from('repair_orders').select().eq('barcode', barcode).single();
      return Result.success(RepairOrderModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Get repair order by barcode failure: $barcode', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<RepairOrderEntity, Failure>> createRepairOrder(RepairOrderEntity repair) async {
    try {
      final model = RepairOrderModel.fromEntity(repair);
      final response = await _client.from('repair_orders').insert(model.toJson()).select().single();
      return Result.success(RepairOrderModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Create repair order failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<RepairOrderEntity, Failure>> updateRepairOrder(RepairOrderEntity repair) async {
    try {
      final model = RepairOrderModel.fromEntity(repair);
      final response = await _client
          .from('repair_orders')
          .update(model.toJson())
          .eq('id', repair.id)
          .select()
          .single();
      return Result.success(RepairOrderModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Update repair order failure for ID: ${repair.id}', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>, Failure>> getStatusHistory(String repairId) async {
    try {
      final response = await _client
          .from('repair_status_history')
          .select('*, changed_by_user:users(full_name)')
          .eq('repair_order_id', repairId)
          .order('changed_at', ascending: true);

      final list = (response as List).cast<Map<String, dynamic>>();
      return Result.success(list);
    } catch (e, stack) {
      Log.e('Get status history failure for ID: $repairId', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }
}
