import 'package:expense_tracker/domain/repositories/auth_repository.dart';

class SignupUser {
  final AuthRepository repository;

  SignupUser(this.repository);

  Future<void> call(String email, String password) {
    return repository.signup(email, password);
  }
}