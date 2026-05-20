import 'package:expense_tracker/feature/screen/home_view/domain/entities/home_user_entities.dart';
import 'package:expense_tracker/feature/screen/home_view/domain/repositories/home_repositories.dart';

class HomeScreenUseCase{
  final HomeRepository repository;

  HomeScreenUseCase(this.repository);


  Future<List<User>> call({int page = 1}) {
    return repository.fetchUser(page: page);
  }
}