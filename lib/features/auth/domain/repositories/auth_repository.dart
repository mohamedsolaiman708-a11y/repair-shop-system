import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<UserEntity, Failure>> login({
    required String email,
    required String password,
  });

  Future<Result<void, Failure>> logout();

  Future<Result<UserEntity?, Failure>> getCurrentUser();

  Stream<UserEntity?> get onAuthStateChanged;
}
