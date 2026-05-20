import 'package:dio/dio.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<void> login(String email, String password) async {
    await dio.post('/api/login', data: {
      'email': email,
      'password': password,
    });
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> signup(String email, String password) {
    // TODO: implement signup
    throw UnimplementedError();
  }
}
