import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings_entity.freezed.dart';

enum AppThemeMode {
  light,
  dark,
  system;

  static AppThemeMode fromName(String name) => values.firstWhere(
        (e) => e.name == name,
        orElse: () => AppThemeMode.system,
      );
}

@freezed
abstract class UserSettingsEntity with _$UserSettingsEntity {
  const factory UserSettingsEntity({
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default('INR') String currency,
    String? defaultCategoryId,
    String? defaultAccountId,
    /// True = show a confirmation screen before saving an automation-captured
    /// transaction. False = save automatically for high-confidence parses.
    @Default(true) bool automationConfirmationMode,
    /// Random per-user secret automation clients (iOS Shortcuts, MacroDroid)
    /// embed in their write to `automation_inbox`, checked by Firestore
    /// rules — see firestore.rules. Null until the user generates one from
    /// Settings → Automation. Regenerating overwrites this value, which
    /// immediately invalidates the old token everywhere it was configured.
    String? automationToken,
    @Default(false) bool googleSheetsEnabled,
    @Default(true) bool budgetNotificationsEnabled,
    @Default(true) bool recurringNotificationsEnabled,
    @Default(true) bool importedTransactionNotificationsEnabled,
  }) = _UserSettingsEntity;
}
