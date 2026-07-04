import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/whatsapp_repository_impl.dart';
import '../../domain/entities/whatsapp_log.dart';
import '../../domain/repositories/whatsapp_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final whatsappRepositoryProvider = Provider<WhatsAppRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return WhatsAppRepositoryImpl(client);
});

final repairOrderWhatsAppLogsProvider = FutureProvider.family.autoDispose<List<WhatsAppLogEntity>, String>((ref, repairOrderId) async {
  if (repairOrderId.isEmpty) return const [];
  final repo = ref.watch(whatsappRepositoryProvider);
  final result = await repo.getLogsByRepairOrder(repairOrderId);
  return result.fold(
    (list) => list,
    (failure) => throw Exception(failure.message),
  );
});

class WhatsAppNotifier extends AutoDisposeAsyncNotifier<WhatsAppLogEntity?> {
  late final WhatsAppRepository _repository;

  @override
  FutureOr<WhatsAppLogEntity?> build() {
    _repository = ref.watch(whatsappRepositoryProvider);
    return null;
  }

  Future<WhatsAppLogEntity?> triggerNotification({
    required String repairOrderId,
    required String templateName,
    required String phone,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.sendNotification(
      repairOrderId: repairOrderId,
      templateName: templateName,
      phone: phone,
    );
    return result.fold(
      (log) {
        state = AsyncValue.data(log);
        ref.invalidate(repairOrderWhatsAppLogsProvider(repairOrderId));
        return log;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }

  Future<WhatsAppLogEntity?> retry(String logId, String repairOrderId) async {
    state = const AsyncValue.loading();
    final result = await _repository.retryNotification(logId);
    return result.fold(
      (log) {
        state = AsyncValue.data(log);
        ref.invalidate(repairOrderWhatsAppLogsProvider(repairOrderId));
        return log;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }
}

final whatsappNotifierProvider = AutoDisposeAsyncNotifierProvider<WhatsAppNotifier, WhatsAppLogEntity?>(() {
  return WhatsAppNotifier();
});
