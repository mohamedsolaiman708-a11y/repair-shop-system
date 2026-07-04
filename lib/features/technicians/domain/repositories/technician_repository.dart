import '../../../../core/errors/failures.dart';
import '../entities/technician.dart';

abstract class TechnicianRepository {
  Future<Result<List<TechnicianEntity>, Failure>> getTechniciansByBranch(String branchId);
  
  Future<Result<TechnicianEntity, Failure>> createTechnician(TechnicianEntity technician);

  Future<Result<TechnicianEntity, Failure>> updateTechnician(TechnicianEntity technician);
}
