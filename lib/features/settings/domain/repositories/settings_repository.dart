import '../entities/user_settings_entity.dart';

abstract class SettingsRepository {
  Stream<UserSettingsEntity> watchSettings();

  Future<void> updateSettings(UserSettingsEntity settings);
}
