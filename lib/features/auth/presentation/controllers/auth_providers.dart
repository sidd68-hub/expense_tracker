import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firebase_auth_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuthDataSource());
});

/// The single source of truth for "who is signed in". The router redirect
/// and every uid-scoped repository provider depend on this.
final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// Convenience provider for the current uid, used to scope every Firestore
/// query to `users/{uid}/...`. Throws if read while signed out — callers
/// should only read this from behind an auth-gated route.
final currentUidProvider = Provider<String>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    throw StateError('currentUidProvider read while signed out');
  }
  return user.uid;
});
