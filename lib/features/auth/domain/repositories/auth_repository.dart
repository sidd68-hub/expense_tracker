import '../entities/app_user.dart';

/// Abstraction over authentication so presentation code never touches
/// FirebaseAuth/GoogleSignIn directly.
abstract class AuthRepository {
  /// Emits the current user (or null when signed out) whenever auth state changes.
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  Future<void> signInWithEmail({required String email, required String password});

  Future<void> signUpWithEmail({required String email, required String password});

  Future<void> signInWithGoogle();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();

  /// Deletes the signed-in user's account. Callers must have re-authenticated
  /// recently, per Firebase's `requires-recent-login` requirement.
  Future<void> deleteAccount();
}
