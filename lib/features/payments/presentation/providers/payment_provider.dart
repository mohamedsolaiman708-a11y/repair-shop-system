import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/payment_repository_impl.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PaymentRepositoryImpl(client);
});

final repairOrderPaymentsProvider = FutureProvider.family.autoDispose<List<PaymentEntity>, String>((ref, repairOrderId) async {
  if (repairOrderId.isEmpty) return const [];
  final repo = ref.watch(paymentRepositoryProvider);
  final result = await repo.getPaymentsByRepairOrder(repairOrderId);
  return result.fold(
    (list) => list,
    (failure) => throw Exception(failure.message),
  );
});

class PaymentNotifier extends AutoDisposeAsyncNotifier<PaymentEntity?> {
  late final PaymentRepository _repository;

  @override
  FutureOr<PaymentEntity?> build() {
    _repository = ref.watch(paymentRepositoryProvider);
    return null;
  }

  Future<PaymentEntity?> addPayment(PaymentEntity payment) async {
    state = const AsyncValue.loading();
    final result = await _repository.createPayment(payment);
    return result.fold(
      (newPayment) {
        state = AsyncValue.data(newPayment);
        ref.invalidate(repairOrderPaymentsProvider(payment.repairOrderId));
        return newPayment;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }
}

final paymentNotifierProvider = AutoDisposeAsyncNotifierProvider<PaymentNotifier, PaymentEntity?>(() {
  return PaymentNotifier();
});
