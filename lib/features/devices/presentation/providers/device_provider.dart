import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DeviceRepositoryImpl(client);
});

final customerDevicesProvider = FutureProvider.family.autoDispose<List<DeviceEntity>, String>((ref, customerId) async {
  if (customerId.isEmpty) return const [];
  final repo = ref.watch(deviceRepositoryProvider);
  final result = await repo.getDevicesByCustomerId(customerId);
  return result.fold(
    (list) => list,
    (failure) => throw Exception(failure.message),
  );
});

class DeviceNotifier extends AutoDisposeAsyncNotifier<DeviceEntity?> {
  late final DeviceRepository _repository;

  @override
  FutureOr<DeviceEntity?> build() {
    _repository = ref.watch(deviceRepositoryProvider);
    return null;
  }

  Future<DeviceEntity?> create(DeviceEntity device) async {
    state = const AsyncValue.loading();
    final result = await _repository.createDevice(device);
    return result.fold(
      (newDevice) {
        state = AsyncValue.data(newDevice);
        return newDevice;
      },
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return null;
      },
    );
  }
}

final deviceNotifierProvider = AutoDisposeAsyncNotifierProvider<DeviceNotifier, DeviceEntity?>(() {
  return DeviceNotifier();
});
