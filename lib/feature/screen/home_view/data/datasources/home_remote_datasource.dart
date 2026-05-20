import 'package:expense_tracker/feature/screen/home_view/data/model/user_new_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<NewUserModel>> fetchUser({int page});
}