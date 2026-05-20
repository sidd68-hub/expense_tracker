import 'package:expense_tracker/feature/screen/home_view/domain/entities/home_user_entities.dart';

abstract class HomeRepository {
  Future<List<User>> fetchUser({int page});
}