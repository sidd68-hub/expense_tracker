import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_providers.dart';
import '../../data/settings_repository_impl.dart';
import '../../domain/entities/user_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final uid = ref.watch(currentUidProvider);
  return SettingsRepositoryImpl(uid: uid);
});

final userSettingsProvider = StreamProvider.autoDispose<UserSettingsEntity>((ref) {
  return ref.watch(settingsRepositoryProvider).watchSettings();
});
