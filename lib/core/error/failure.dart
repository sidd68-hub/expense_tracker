/// Base type for all recoverable failures surfaced to the presentation layer.
///
/// Repositories/data sources must catch platform exceptions (FirebaseException,
/// SocketException, etc.) and translate them into one of these so that UI code
/// never needs to know about Firebase/network specifics.
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Changes will sync when you\'re back online.']);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested item could not be found.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'You don\'t have permission to do that.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong. Please try again.']);
}
