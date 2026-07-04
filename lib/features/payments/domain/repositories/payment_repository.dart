import '../../../../core/errors/failures.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Result<List<PaymentEntity>, Failure>> getPaymentsByRepairOrder(String repairOrderId);
  
  Future<Result<PaymentEntity, Failure>> createPayment(PaymentEntity payment);
}
