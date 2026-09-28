// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSettingsEntity {

 AppThemeMode get themeMode; String get currency; String? get defaultCategoryId; String? get defaultAccountId;/// True = show a confirmation screen before saving an automation-captured
/// transaction. False = save automatically for high-confidence parses.
 bool get automationConfirmationMode;/// Random per-user secret automation clients (iOS Shortcuts, MacroDroid)
/// embed in their write to `automation_inbox`, checked by Firestore
/// rules — see firestore.rules. Null until the user generates one from
/// Settings → Automation. Regenerating overwrites this value, which
/// immediately invalidates the old token everywhere it was configured.
 String? get automationToken; bool get googleSheetsEnabled; bool get budgetNotificationsEnabled; bool get recurringNotificationsEnabled; bool get importedTransactionNotificationsEnabled;
/// Create a copy of UserSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsEntityCopyWith<UserSettingsEntity> get copyWith => _$UserSettingsEntityCopyWithImpl<UserSettingsEntity>(this as UserSettingsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsEntity&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.defaultCategoryId, defaultCategoryId) || other.defaultCategoryId == defaultCategoryId)&&(identical(other.defaultAccountId, defaultAccountId) || other.defaultAccountId == defaultAccountId)&&(identical(other.automationConfirmationMode, automationConfirmationMode) || other.automationConfirmationMode == automationConfirmationMode)&&(identical(other.automationToken, automationToken) || other.automationToken == automationToken)&&(identical(other.googleSheetsEnabled, googleSheetsEnabled) || other.googleSheetsEnabled == googleSheetsEnabled)&&(identical(other.budgetNotificationsEnabled, budgetNotificationsEnabled) || other.budgetNotificationsEnabled == budgetNotificationsEnabled)&&(identical(other.recurringNotificationsEnabled, recurringNotificationsEnabled) || other.recurringNotificationsEnabled == recurringNotificationsEnabled)&&(identical(other.importedTransactionNotificationsEnabled, importedTransactionNotificationsEnabled) || other.importedTransactionNotificationsEnabled == importedTransactionNotificationsEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,currency,defaultCategoryId,defaultAccountId,automationConfirmationMode,automationToken,googleSheetsEnabled,budgetNotificationsEnabled,recurringNotificationsEnabled,importedTransactionNotificationsEnabled);

@override
String toString() {
  return 'UserSettingsEntity(themeMode: $themeMode, currency: $currency, defaultCategoryId: $defaultCategoryId, defaultAccountId: $defaultAccountId, automationConfirmationMode: $automationConfirmationMode, automationToken: $automationToken, googleSheetsEnabled: $googleSheetsEnabled, budgetNotificationsEnabled: $budgetNotificationsEnabled, recurringNotificationsEnabled: $recurringNotificationsEnabled, importedTransactionNotificationsEnabled: $importedTransactionNotificationsEnabled)';
}


}

/// @nodoc
abstract mixin class $UserSettingsEntityCopyWith<$Res>  {
  factory $UserSettingsEntityCopyWith(UserSettingsEntity value, $Res Function(UserSettingsEntity) _then) = _$UserSettingsEntityCopyWithImpl;
@useResult
$Res call({
 AppThemeMode themeMode, String currency, String? defaultCategoryId, String? defaultAccountId, bool automationConfirmationMode, String? automationToken, bool googleSheetsEnabled, bool budgetNotificationsEnabled, bool recurringNotificationsEnabled, bool importedTransactionNotificationsEnabled
});




}
/// @nodoc
class _$UserSettingsEntityCopyWithImpl<$Res>
    implements $UserSettingsEntityCopyWith<$Res> {
  _$UserSettingsEntityCopyWithImpl(this._self, this._then);

  final UserSettingsEntity _self;
  final $Res Function(UserSettingsEntity) _then;

/// Create a copy of UserSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? currency = null,Object? defaultCategoryId = freezed,Object? defaultAccountId = freezed,Object? automationConfirmationMode = null,Object? automationToken = freezed,Object? googleSheetsEnabled = null,Object? budgetNotificationsEnabled = null,Object? recurringNotificationsEnabled = null,Object? importedTransactionNotificationsEnabled = null,}) {
  return _then(UserSettingsEntity(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,defaultCategoryId: freezed == defaultCategoryId ? _self.defaultCategoryId : defaultCategoryId // ignore: cast_nullable_to_non_nullable
as String?,defaultAccountId: freezed == defaultAccountId ? _self.defaultAccountId : defaultAccountId // ignore: cast_nullable_to_non_nullable
as String?,automationConfirmationMode: null == automationConfirmationMode ? _self.automationConfirmationMode : automationConfirmationMode // ignore: cast_nullable_to_non_nullable
as bool,automationToken: freezed == automationToken ? _self.automationToken : automationToken // ignore: cast_nullable_to_non_nullable
as String?,googleSheetsEnabled: null == googleSheetsEnabled ? _self.googleSheetsEnabled : googleSheetsEnabled // ignore: cast_nullable_to_non_nullable
as bool,budgetNotificationsEnabled: null == budgetNotificationsEnabled ? _self.budgetNotificationsEnabled : budgetNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,recurringNotificationsEnabled: null == recurringNotificationsEnabled ? _self.recurringNotificationsEnabled : recurringNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,importedTransactionNotificationsEnabled: null == importedTransactionNotificationsEnabled ? _self.importedTransactionNotificationsEnabled : importedTransactionNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettingsEntity].
extension UserSettingsEntityPatterns on UserSettingsEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettingsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettingsEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettingsEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserSettingsEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettingsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettingsEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppThemeMode themeMode,  String currency,  String? defaultCategoryId,  String? defaultAccountId,  bool automationConfirmationMode,  String? automationToken,  bool googleSheetsEnabled,  bool budgetNotificationsEnabled,  bool recurringNotificationsEnabled,  bool importedTransactionNotificationsEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettingsEntity() when $default != null:
return $default(_that.themeMode,_that.currency,_that.defaultCategoryId,_that.defaultAccountId,_that.automationConfirmationMode,_that.automationToken,_that.googleSheetsEnabled,_that.budgetNotificationsEnabled,_that.recurringNotificationsEnabled,_that.importedTransactionNotificationsEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppThemeMode themeMode,  String currency,  String? defaultCategoryId,  String? defaultAccountId,  bool automationConfirmationMode,  String? automationToken,  bool googleSheetsEnabled,  bool budgetNotificationsEnabled,  bool recurringNotificationsEnabled,  bool importedTransactionNotificationsEnabled)  $default,) {final _that = this;
switch (_that) {
case _UserSettingsEntity():
return $default(_that.themeMode,_that.currency,_that.defaultCategoryId,_that.defaultAccountId,_that.automationConfirmationMode,_that.automationToken,_that.googleSheetsEnabled,_that.budgetNotificationsEnabled,_that.recurringNotificationsEnabled,_that.importedTransactionNotificationsEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppThemeMode themeMode,  String currency,  String? defaultCategoryId,  String? defaultAccountId,  bool automationConfirmationMode,  String? automationToken,  bool googleSheetsEnabled,  bool budgetNotificationsEnabled,  bool recurringNotificationsEnabled,  bool importedTransactionNotificationsEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UserSettingsEntity() when $default != null:
return $default(_that.themeMode,_that.currency,_that.defaultCategoryId,_that.defaultAccountId,_that.automationConfirmationMode,_that.automationToken,_that.googleSheetsEnabled,_that.budgetNotificationsEnabled,_that.recurringNotificationsEnabled,_that.importedTransactionNotificationsEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _UserSettingsEntity implements UserSettingsEntity {
  const _UserSettingsEntity({this.themeMode = AppThemeMode.system, this.currency = 'INR', this.defaultCategoryId, this.defaultAccountId, this.automationConfirmationMode = true, this.automationToken, this.googleSheetsEnabled = false, this.budgetNotificationsEnabled = true, this.recurringNotificationsEnabled = true, this.importedTransactionNotificationsEnabled = true});
  

@override@JsonKey() final  AppThemeMode themeMode;
@override@JsonKey() final  String currency;
@override final  String? defaultCategoryId;
@override final  String? defaultAccountId;
/// True = show a confirmation screen before saving an automation-captured
/// transaction. False = save automatically for high-confidence parses.
@override@JsonKey() final  bool automationConfirmationMode;
/// Random per-user secret automation clients (iOS Shortcuts, MacroDroid)
/// embed in their write to `automation_inbox`, checked by Firestore
/// rules — see firestore.rules. Null until the user generates one from
/// Settings → Automation. Regenerating overwrites this value, which
/// immediately invalidates the old token everywhere it was configured.
@override final  String? automationToken;
@override@JsonKey() final  bool googleSheetsEnabled;
@override@JsonKey() final  bool budgetNotificationsEnabled;
@override@JsonKey() final  bool recurringNotificationsEnabled;
@override@JsonKey() final  bool importedTransactionNotificationsEnabled;

/// Create a copy of UserSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsEntityCopyWith<_UserSettingsEntity> get copyWith => __$UserSettingsEntityCopyWithImpl<_UserSettingsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettingsEntity&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.defaultCategoryId, defaultCategoryId) || other.defaultCategoryId == defaultCategoryId)&&(identical(other.defaultAccountId, defaultAccountId) || other.defaultAccountId == defaultAccountId)&&(identical(other.automationConfirmationMode, automationConfirmationMode) || other.automationConfirmationMode == automationConfirmationMode)&&(identical(other.automationToken, automationToken) || other.automationToken == automationToken)&&(identical(other.googleSheetsEnabled, googleSheetsEnabled) || other.googleSheetsEnabled == googleSheetsEnabled)&&(identical(other.budgetNotificationsEnabled, budgetNotificationsEnabled) || other.budgetNotificationsEnabled == budgetNotificationsEnabled)&&(identical(other.recurringNotificationsEnabled, recurringNotificationsEnabled) || other.recurringNotificationsEnabled == recurringNotificationsEnabled)&&(identical(other.importedTransactionNotificationsEnabled, importedTransactionNotificationsEnabled) || other.importedTransactionNotificationsEnabled == importedTransactionNotificationsEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,currency,defaultCategoryId,defaultAccountId,automationConfirmationMode,automationToken,googleSheetsEnabled,budgetNotificationsEnabled,recurringNotificationsEnabled,importedTransactionNotificationsEnabled);

@override
String toString() {
  return 'UserSettingsEntity(themeMode: $themeMode, currency: $currency, defaultCategoryId: $defaultCategoryId, defaultAccountId: $defaultAccountId, automationConfirmationMode: $automationConfirmationMode, automationToken: $automationToken, googleSheetsEnabled: $googleSheetsEnabled, budgetNotificationsEnabled: $budgetNotificationsEnabled, recurringNotificationsEnabled: $recurringNotificationsEnabled, importedTransactionNotificationsEnabled: $importedTransactionNotificationsEnabled)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsEntityCopyWith<$Res> implements $UserSettingsEntityCopyWith<$Res> {
  factory _$UserSettingsEntityCopyWith(_UserSettingsEntity value, $Res Function(_UserSettingsEntity) _then) = __$UserSettingsEntityCopyWithImpl;
@override @useResult
$Res call({
 AppThemeMode themeMode, String currency, String? defaultCategoryId, String? defaultAccountId, bool automationConfirmationMode, String? automationToken, bool googleSheetsEnabled, bool budgetNotificationsEnabled, bool recurringNotificationsEnabled, bool importedTransactionNotificationsEnabled
});




}
/// @nodoc
class __$UserSettingsEntityCopyWithImpl<$Res>
    implements _$UserSettingsEntityCopyWith<$Res> {
  __$UserSettingsEntityCopyWithImpl(this._self, this._then);

  final _UserSettingsEntity _self;
  final $Res Function(_UserSettingsEntity) _then;

/// Create a copy of UserSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? currency = null,Object? defaultCategoryId = freezed,Object? defaultAccountId = freezed,Object? automationConfirmationMode = null,Object? automationToken = freezed,Object? googleSheetsEnabled = null,Object? budgetNotificationsEnabled = null,Object? recurringNotificationsEnabled = null,Object? importedTransactionNotificationsEnabled = null,}) {
  return _then(_UserSettingsEntity(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as AppThemeMode,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,defaultCategoryId: freezed == defaultCategoryId ? _self.defaultCategoryId : defaultCategoryId // ignore: cast_nullable_to_non_nullable
as String?,defaultAccountId: freezed == defaultAccountId ? _self.defaultAccountId : defaultAccountId // ignore: cast_nullable_to_non_nullable
as String?,automationConfirmationMode: null == automationConfirmationMode ? _self.automationConfirmationMode : automationConfirmationMode // ignore: cast_nullable_to_non_nullable
as bool,automationToken: freezed == automationToken ? _self.automationToken : automationToken // ignore: cast_nullable_to_non_nullable
as String?,googleSheetsEnabled: null == googleSheetsEnabled ? _self.googleSheetsEnabled : googleSheetsEnabled // ignore: cast_nullable_to_non_nullable
as bool,budgetNotificationsEnabled: null == budgetNotificationsEnabled ? _self.budgetNotificationsEnabled : budgetNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,recurringNotificationsEnabled: null == recurringNotificationsEnabled ? _self.recurringNotificationsEnabled : recurringNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,importedTransactionNotificationsEnabled: null == importedTransactionNotificationsEnabled ? _self.importedTransactionNotificationsEnabled : importedTransactionNotificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
