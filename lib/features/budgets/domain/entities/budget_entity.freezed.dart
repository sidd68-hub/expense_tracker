// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetEntity {

 String get id; BudgetScope get scope;/// Required when [scope] is [BudgetScope.category], null for overall budgets.
 String? get categoryId;/// "yyyy-MM" — a budget is scoped to a single calendar month.
 String get monthKey; int get limitMinor; String get currency; List<int> get alertThresholds; DateTime? get createdAt;
/// Create a copy of BudgetEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetEntityCopyWith<BudgetEntity> get copyWith => _$BudgetEntityCopyWithImpl<BudgetEntity>(this as BudgetEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.monthKey, monthKey) || other.monthKey == monthKey)&&(identical(other.limitMinor, limitMinor) || other.limitMinor == limitMinor)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other.alertThresholds, alertThresholds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,scope,categoryId,monthKey,limitMinor,currency,const DeepCollectionEquality().hash(alertThresholds),createdAt);

@override
String toString() {
  return 'BudgetEntity(id: $id, scope: $scope, categoryId: $categoryId, monthKey: $monthKey, limitMinor: $limitMinor, currency: $currency, alertThresholds: $alertThresholds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BudgetEntityCopyWith<$Res>  {
  factory $BudgetEntityCopyWith(BudgetEntity value, $Res Function(BudgetEntity) _then) = _$BudgetEntityCopyWithImpl;
@useResult
$Res call({
 String id, BudgetScope scope, String? categoryId, String monthKey, int limitMinor, String currency, List<int> alertThresholds, DateTime? createdAt
});




}
/// @nodoc
class _$BudgetEntityCopyWithImpl<$Res>
    implements $BudgetEntityCopyWith<$Res> {
  _$BudgetEntityCopyWithImpl(this._self, this._then);

  final BudgetEntity _self;
  final $Res Function(BudgetEntity) _then;

/// Create a copy of BudgetEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? scope = null,Object? categoryId = freezed,Object? monthKey = null,Object? limitMinor = null,Object? currency = null,Object? alertThresholds = null,Object? createdAt = freezed,}) {
  return _then(BudgetEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as BudgetScope,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,monthKey: null == monthKey ? _self.monthKey : monthKey // ignore: cast_nullable_to_non_nullable
as String,limitMinor: null == limitMinor ? _self.limitMinor : limitMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,alertThresholds: null == alertThresholds ? _self.alertThresholds : alertThresholds // ignore: cast_nullable_to_non_nullable
as List<int>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetEntity].
extension BudgetEntityPatterns on BudgetEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetEntity value)  $default,){
final _that = this;
switch (_that) {
case _BudgetEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  BudgetScope scope,  String? categoryId,  String monthKey,  int limitMinor,  String currency,  List<int> alertThresholds,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetEntity() when $default != null:
return $default(_that.id,_that.scope,_that.categoryId,_that.monthKey,_that.limitMinor,_that.currency,_that.alertThresholds,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  BudgetScope scope,  String? categoryId,  String monthKey,  int limitMinor,  String currency,  List<int> alertThresholds,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BudgetEntity():
return $default(_that.id,_that.scope,_that.categoryId,_that.monthKey,_that.limitMinor,_that.currency,_that.alertThresholds,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  BudgetScope scope,  String? categoryId,  String monthKey,  int limitMinor,  String currency,  List<int> alertThresholds,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BudgetEntity() when $default != null:
return $default(_that.id,_that.scope,_that.categoryId,_that.monthKey,_that.limitMinor,_that.currency,_that.alertThresholds,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetEntity implements BudgetEntity {
  const _BudgetEntity({required this.id, required this.scope, this.categoryId, required this.monthKey, required this.limitMinor, this.currency = 'INR',  List<int> alertThresholds = const [80, 100], this.createdAt}): _alertThresholds = alertThresholds;
  

@override final  String id;
@override final  BudgetScope scope;
/// Required when [scope] is [BudgetScope.category], null for overall budgets.
@override final  String? categoryId;
/// "yyyy-MM" — a budget is scoped to a single calendar month.
@override final  String monthKey;
@override final  int limitMinor;
@override@JsonKey() final  String currency;
 final  List<int> _alertThresholds;
@override@JsonKey() List<int> get alertThresholds {
  if (_alertThresholds is EqualUnmodifiableListView) return _alertThresholds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alertThresholds);
}

@override final  DateTime? createdAt;

/// Create a copy of BudgetEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetEntityCopyWith<_BudgetEntity> get copyWith => __$BudgetEntityCopyWithImpl<_BudgetEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.monthKey, monthKey) || other.monthKey == monthKey)&&(identical(other.limitMinor, limitMinor) || other.limitMinor == limitMinor)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other._alertThresholds, _alertThresholds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,scope,categoryId,monthKey,limitMinor,currency,const DeepCollectionEquality().hash(_alertThresholds),createdAt);

@override
String toString() {
  return 'BudgetEntity(id: $id, scope: $scope, categoryId: $categoryId, monthKey: $monthKey, limitMinor: $limitMinor, currency: $currency, alertThresholds: $alertThresholds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BudgetEntityCopyWith<$Res> implements $BudgetEntityCopyWith<$Res> {
  factory _$BudgetEntityCopyWith(_BudgetEntity value, $Res Function(_BudgetEntity) _then) = __$BudgetEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, BudgetScope scope, String? categoryId, String monthKey, int limitMinor, String currency, List<int> alertThresholds, DateTime? createdAt
});




}
/// @nodoc
class __$BudgetEntityCopyWithImpl<$Res>
    implements _$BudgetEntityCopyWith<$Res> {
  __$BudgetEntityCopyWithImpl(this._self, this._then);

  final _BudgetEntity _self;
  final $Res Function(_BudgetEntity) _then;

/// Create a copy of BudgetEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? scope = null,Object? categoryId = freezed,Object? monthKey = null,Object? limitMinor = null,Object? currency = null,Object? alertThresholds = null,Object? createdAt = freezed,}) {
  return _then(_BudgetEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as BudgetScope,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,monthKey: null == monthKey ? _self.monthKey : monthKey // ignore: cast_nullable_to_non_nullable
as String,limitMinor: null == limitMinor ? _self.limitMinor : limitMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,alertThresholds: null == alertThresholds ? _self._alertThresholds : alertThresholds // ignore: cast_nullable_to_non_nullable
as List<int>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
