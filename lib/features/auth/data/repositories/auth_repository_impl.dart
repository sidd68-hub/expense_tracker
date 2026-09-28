import '../../../../core/error/exception_mapper.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final FirebaseAuthDataSource _dataSource;

  @override
  Stream<AppUser?> authStateChanges() => _dataSource.authStateChanges();

  @override
  AppUser? get currentUser => _dataSource.currentUser;

  @override
  Future<void> signInWithEmail({required String email, required String password}) async {
    try {
      await _dataSource.signInWithEmail(email: email, password: password);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> signUpWithEmail({required String email, required String password}) async {
    try {
      await _dataSource.signUpWithEmail(email: email, password: password);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _dataSource.signInWithGoogle();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _dataSource.sendPasswordResetEmail(email);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dataSource.deleteAccount();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
