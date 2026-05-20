// domain/entities/user_entity.dart
class UserEntity {
  final String userId;
  final String name;
  final String email;
  final String token;

  UserEntity({
    required this.userId,
    required this.name,
    required this.email,
    required this.token,
  });
}
