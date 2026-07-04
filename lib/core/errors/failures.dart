abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}

/// A generic class that holds a value or a failure.
class Result<S, F extends Failure> {
  final S? _success;
  final F? _failure;

  const Result.success(S success)
      : _success = success,
        _failure = null;

  const Result.failure(F failure)
      : _success = null,
        _failure = failure;

  bool get isSuccess => _success != null;
  bool get isFailure => _failure != null;

  S get success => _success!;
  F get failure => _failure!;

  R fold<R>(R Function(S success) onSuccess, R Function(F failure) onFailure) {
    if (isSuccess) {
      return onSuccess(_success as S);
    } else {
      return onFailure(_failure as F);
    }
  }
}
