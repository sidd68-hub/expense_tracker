import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'failure.dart';

/// Translates platform/plugin exceptions into a [Failure] the UI can render
/// without knowing anything about Firebase or sockets.
Failure mapExceptionToFailure(Object error) {
  if (error is Failure) return error;

  if (error is FirebaseAuthException) {
    return AuthFailure(_authMessageFor(error.code));
  }

  if (error is FirebaseException) {
    if (error.code == 'permission-denied') {
      return const PermissionFailure();
    }
    if (error.code == 'unavailable') {
      return const NetworkFailure();
    }
    return UnknownFailure(error.message ?? 'A Firebase error occurred.');
  }

  if (error is SocketException || error is HttpException) {
    return const NetworkFailure();
  }

  return const UnknownFailure();
}

String _authMessageFor(String code) {
  switch (code) {
    case 'user-not-found':
    case 'wrong-password':
    case 'invalid-credential':
      return 'Incorrect email or password.';
    case 'email-already-in-use':
      return 'An account already exists with this email.';
    case 'weak-password':
      return 'Please choose a stronger password.';
    case 'invalid-email':
      return 'Please enter a valid email address.';
    case 'user-disabled':
      return 'This account has been disabled.';
    case 'too-many-requests':
      return 'Too many attempts. Please try again later.';
    case 'requires-recent-login':
      return 'Please sign in again to continue.';
    case 'network-request-failed':
      return 'No internet connection. Please try again.';
    default:
      return 'Authentication failed. Please try again.';
  }
}
