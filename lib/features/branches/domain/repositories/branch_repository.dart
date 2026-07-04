import '../../../../core/errors/failures.dart';
import '../entities/branch.dart';

abstract class BranchRepository {
  Future<Result<List<BranchEntity>, Failure>> getBranches();
  
  Future<Result<BranchEntity, Failure>> getBranch(String id);
  
  Future<Result<BranchEntity, Failure>> createBranch(BranchEntity branch);
  
  Future<Result<BranchEntity, Failure>> updateBranch(BranchEntity branch);
}
