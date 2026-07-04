import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../models/device_model.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final supabase.SupabaseClient _client;

  DeviceRepositoryImpl(this._client);

  @override
  Future<Result<List<DeviceEntity>, Failure>> getDevicesByCustomerId(String customerId) async {
    try {
      final response = await _client.from('devices').select().eq('customer_id', customerId);
      final list = (response as List)
          .map((json) => DeviceModel.fromJson(json).toEntity())
          .toList();
      return Result.success(list);
    } catch (e, stack) {
      Log.e('Get devices failure for customer: $customerId', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<DeviceEntity, Failure>> createDevice(DeviceEntity device) async {
    try {
      final model = DeviceModel.fromEntity(device);
      final response = await _client.from('devices').insert(model.toJson()).select().single();
      return Result.success(DeviceModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Create device failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<DeviceEntity, Failure>> getDevice(String id) async {
    try {
      final response = await _client.from('devices').select().eq('id', id).single();
      return Result.success(DeviceModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Get device failure for ID: $id', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }
}
