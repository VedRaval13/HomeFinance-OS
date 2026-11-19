/// Base Failure model for Clean Architecture error handling.
abstract class Failure {
  final String message;
  final dynamic cause;

  const Failure(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message';
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.cause]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.cause]);
}

class SecurityFailure extends Failure {
  const SecurityFailure(super.message, [super.cause]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, [super.cause]);
}
