import '../../../../core/errors/failures.dart';
import '../entities/device.dart';

abstract class DeviceRepository {
  Future<Result<List<DeviceEntity>, Failure>> getDevicesByCustomerId(String customerId);

  Future<Result<DeviceEntity, Failure>> createDevice(DeviceEntity device);

  Future<Result<DeviceEntity, Failure>> getDevice(String id);
}
