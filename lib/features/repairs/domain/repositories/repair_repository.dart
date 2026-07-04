import '../../../../core/errors/failures.dart';
import '../entities/repair_order.dart';

abstract class RepairRepository {
  Future<Result<List<RepairOrderEntity>, Failure>> getRepairOrders({String? status, String? query});

  Future<Result<RepairOrderEntity, Failure>> getRepairOrderById(String id);

  Future<Result<RepairOrderEntity, Failure>> getRepairOrderByBarcode(String barcode);

  Future<Result<RepairOrderEntity, Failure>> createRepairOrder(RepairOrderEntity repair);

  Future<Result<RepairOrderEntity, Failure>> updateRepairOrder(RepairOrderEntity repair);

  Future<Result<List<Map<String, dynamic>>, Failure>> getStatusHistory(String repairId);
}
