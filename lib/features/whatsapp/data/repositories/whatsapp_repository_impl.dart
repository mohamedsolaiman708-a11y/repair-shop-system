import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/whatsapp_log.dart';
import '../../domain/repositories/whatsapp_repository.dart';
import '../models/whatsapp_log_model.dart';

class WhatsAppRepositoryImpl implements WhatsAppRepository {
  final supabase.SupabaseClient _client;

  WhatsAppRepositoryImpl(this._client);

  @override
  Future<Result<List<WhatsAppLogEntity>, Failure>> getLogsByRepairOrder(String repairOrderId) async {
    try {
      final response = await _client
          .from('whatsapp_logs')
          .select()
          .eq('repair_order_id', repairOrderId)
          .order('sent_at', ascending: false);

      final list = (response as List)
          .map((json) => WhatsAppLogModel.fromJson(json).toEntity())
          .toList();
      return Result.success(list);
    } catch (e, stack) {
      Log.e('Get WhatsApp logs failure for repair order: $repairOrderId', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<WhatsAppLogEntity, Failure>> sendNotification({
    required String repairOrderId,
    required String templateName,
    required String phone,
  }) async {
    try {
      // In production, we'd trigger a Supabase Edge Function to integrate with the Meta WhatsApp Cloud API.
      // Here, we simulate the network trigger by inserting the log directly.
      final mockResponse = '{"status": "success", "message_id": "wamid.HBgLOTE4N..."}';
      
      final logModel = WhatsAppLogModel(
        id: '', // Supabase will auto-generate UUID
        repairOrderId: repairOrderId,
        templateName: templateName,
        phone: phone,
        status: WhatsAppStatus.sent.label,
        response: mockResponse,
        sentAt: DateTime.now().toUtc(),
      );

      // Remove id before insert so database defaults trigger
      final jsonToInsert = logModel.toJson()..remove('id');

      final response = await _client.from('whatsapp_logs').insert(jsonToInsert).select().single();
      return Result.success(WhatsAppLogModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Send WhatsApp notification failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<WhatsAppLogEntity, Failure>> retryNotification(String logId) async {
    try {
      // Retrieve the existing log
      final existingRecord = await _client.from('whatsapp_logs').select().eq('id', logId).single();
      final log = WhatsAppLogModel.fromJson(existingRecord).toEntity();

      // Retry sending
      return await sendNotification(
        repairOrderId: log.repairOrderId,
        templateName: log.templateName,
        phone: log.phone,
      );
    } catch (e, stack) {
      Log.e('Retry WhatsApp notification failure for ID: $logId', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }
}
