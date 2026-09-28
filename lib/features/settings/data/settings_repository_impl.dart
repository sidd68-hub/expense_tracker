import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/error/exception_mapper.dart';
import '../../../services/firebase/firestore_paths.dart';
import '../domain/entities/user_settings_entity.dart';
import '../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.uid, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(FirestorePaths.settings(uid)).doc('preferences');

  @override
  Stream<UserSettingsEntity> watchSettings() {
    return _doc.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return const UserSettingsEntity();
      return _fromMap(data);
    });
  }

  @override
  Future<void> updateSettings(UserSettingsEntity settings) async {
    try {
      await _doc.set(_toMap(settings), SetOptions(merge: true));
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  UserSettingsEntity _fromMap(Map<String, dynamic> data) {
    return UserSettingsEntity(
      themeMode: AppThemeMode.fromName(data['themeMode'] as String? ?? 'system'),
      currency: data['currency'] as String? ?? 'INR',
      defaultCategoryId: data['defaultCategoryId'] as String?,
      defaultAccountId: data['defaultAccountId'] as String?,
      automationConfirmationMode: data['automationConfirmationMode'] as bool? ?? true,
      automationToken: data['automationToken'] as String?,
      googleSheetsEnabled: data['googleSheetsEnabled'] as bool? ?? false,
      budgetNotificationsEnabled: data['budgetNotificationsEnabled'] as bool? ?? true,
      recurringNotificationsEnabled: data['recurringNotificationsEnabled'] as bool? ?? true,
      importedTransactionNotificationsEnabled: data['importedTransactionNotificationsEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> _toMap(UserSettingsEntity entity) {
    return {
      'themeMode': entity.themeMode.name,
      'currency': entity.currency,
      'defaultCategoryId': entity.defaultCategoryId,
      'defaultAccountId': entity.defaultAccountId,
      'automationConfirmationMode': entity.automationConfirmationMode,
      'automationToken': entity.automationToken,
      'googleSheetsEnabled': entity.googleSheetsEnabled,
      'budgetNotificationsEnabled': entity.budgetNotificationsEnabled,
      'recurringNotificationsEnabled': entity.recurringNotificationsEnabled,
      'importedTransactionNotificationsEnabled': entity.importedTransactionNotificationsEnabled,
    };
  }
}
