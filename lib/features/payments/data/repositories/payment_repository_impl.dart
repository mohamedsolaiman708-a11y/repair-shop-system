import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final supabase.SupabaseClient _client;

  PaymentRepositoryImpl(this._client);

  @override
  Future<Result<List<PaymentEntity>, Failure>> getPaymentsByRepairOrder(String repairOrderId) async {
    try {
      final response = await _client
          .from('payments')
          .select()
          .eq('repair_order_id', repairOrderId)
          .order('created_at', ascending: false);

      final list = (response as List)
          .map((json) => PaymentModel.fromJson(json).toEntity())
          .toList();
      return Result.success(list);
    } catch (e, stack) {
      Log.e('Get payments failure for repair order: $repairOrderId', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaymentEntity, Failure>> createPayment(PaymentEntity payment) async {
    try {
      final model = PaymentModel.fromEntity(payment);
      final response = await _client.from('payments').insert(model.toJson()).select().single();
      return Result.success(PaymentModel.fromJson(response).toEntity());
    } catch (e, stack) {
      Log.e('Create payment failure', e, stack);
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }
}
