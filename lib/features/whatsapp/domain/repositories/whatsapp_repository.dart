import '../../../../core/errors/failures.dart';
import '../entities/whatsapp_log.dart';

abstract class WhatsAppRepository {
  Future<Result<List<WhatsAppLogEntity>, Failure>> getLogsByRepairOrder(String repairOrderId);

  Future<Result<WhatsAppLogEntity, Failure>> sendNotification({
    required String repairOrderId,
    required String templateName,
    required String phone,
  });

  Future<Result<WhatsAppLogEntity, Failure>> retryNotification(String logId);
}
