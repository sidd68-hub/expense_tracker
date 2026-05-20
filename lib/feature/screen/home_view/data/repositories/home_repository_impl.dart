import 'package:expense_tracker/core/network/api_result.dart';
import 'package:expense_tracker/feature/screen/home_view/data/datasources/home_remote_datasource.dart';
import 'package:expense_tracker/feature/screen/home_view/domain/entities/home_user_entities.dart';
import 'package:expense_tracker/feature/screen/home_view/domain/repositories/home_repositories.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<User>> fetchUser({int page = 1}) async {
    try {
      final models = await remoteDataSource.fetchUser(page: page);

      final users = models
          .map((e) => User(
                id: e.id,
                email: e.email,
                firstName: e.firstName,
                lastName: e.lastName,
                avatar: e.avatar,
              ))
          .toList();
      return users;
    } on ApiFailure catch (e) {
      throw ApiFailure(e.message,e.code);
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
