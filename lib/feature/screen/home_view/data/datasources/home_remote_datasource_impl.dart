import 'package:expense_tracker/core/network/api_client.dart';
import 'package:expense_tracker/core/network/api_result.dart';
import 'package:expense_tracker/feature/screen/home_view/data/model/user_new_model.dart';

import 'home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NewUserModel>> fetchUser({int page = 1}) async {
    final result = await apiClient.get(
      '/api/users',
      queryParameters: {'page': page},
    );
    return result.when(
      success: (response) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final List<dynamic> userJson = data['data'];
        final users = userJson.map((e) => NewUserModel.fromJson(e)).toList();
        return users;
      },
      failure: (message, statusCode) {
        throw ApiFailure(message,statusCode);
      },
    );
  }
}
