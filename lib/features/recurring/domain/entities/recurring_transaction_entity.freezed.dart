// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringTransactionEntity {

 String get id; TransactionType get type; MoneyAmount get amount; String get categoryId; String get accountId; RecurrenceFrequency get frequency; DateTime get startDate; DateTime? get endDate; DateTime? get nextRunDate; String? get remark; bool get isActive;
/// Create a copy of RecurringTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringTransactionEntityCopyWith<RecurringTransactionEntity> get copyWith => _$RecurringTransactionEntityCopyWithImpl<RecurringTransactionEntity>(this as RecurringTransactionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringTransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.nextRunDate, nextRunDate) || other.nextRunDate == nextRunDate)&&(identical(other.remark, remark) || other.remark == remark)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,amount,categoryId,accountId,frequency,startDate,endDate,nextRunDate,remark,isActive);

@override
String toString() {
  return 'RecurringTransactionEntity(id: $id, type: $type, amount: $amount, categoryId: $categoryId, accountId: $accountId, frequency: $frequency, startDate: $startDate, endDate: $endDate, nextRunDate: $nextRunDate, remark: $remark, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $RecurringTransactionEntityCopyWith<$Res>  {
  factory $RecurringTransactionEntityCopyWith(RecurringTransactionEntity value, $Res Function(RecurringTransactionEntity) _then) = _$RecurringTransactionEntityCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type, MoneyAmount amount, String categoryId, String accountId, RecurrenceFrequency frequency, DateTime startDate, DateTime? endDate, DateTime? nextRunDate, String? remark, bool isActive
});




}
/// @nodoc
class _$RecurringTransactionEntityCopyWithImpl<$Res>
    implements $RecurringTransactionEntityCopyWith<$Res> {
  _$RecurringTransactionEntityCopyWithImpl(this._self, this._then);

  final RecurringTransactionEntity _self;
  final $Res Function(RecurringTransactionEntity) _then;

/// Create a copy of RecurringTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? categoryId = null,Object? accountId = null,Object? frequency = null,Object? startDate = null,Object? endDate = freezed,Object? nextRunDate = freezed,Object? remark = freezed,Object? isActive = null,}) {
  return _then(RecurringTransactionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as MoneyAmount,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextRunDate: freezed == nextRunDate ? _self.nextRunDate : nextRunDate // ignore: cast_nullable_to_non_nullable
as DateTime?,remark: freezed == remark ? _self.remark : remark // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringTransactionEntity].
extension RecurringTransactionEntityPatterns on RecurringTransactionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringTransactionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringTransactionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringTransactionEntity value)  $default,){
final _that = this;
switch (_that) {
case _RecurringTransactionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringTransactionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringTransactionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionType type,  MoneyAmount amount,  String categoryId,  String accountId,  RecurrenceFrequency frequency,  DateTime startDate,  DateTime? endDate,  DateTime? nextRunDate,  String? remark,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringTransactionEntity() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.categoryId,_that.accountId,_that.frequency,_that.startDate,_that.endDate,_that.nextRunDate,_that.remark,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionType type,  MoneyAmount amount,  String categoryId,  String accountId,  RecurrenceFrequency frequency,  DateTime startDate,  DateTime? endDate,  DateTime? nextRunDate,  String? remark,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _RecurringTransactionEntity():
return $default(_that.id,_that.type,_that.amount,_that.categoryId,_that.accountId,_that.frequency,_that.startDate,_that.endDate,_that.nextRunDate,_that.remark,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionType type,  MoneyAmount amount,  String categoryId,  String accountId,  RecurrenceFrequency frequency,  DateTime startDate,  DateTime? endDate,  DateTime? nextRunDate,  String? remark,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _RecurringTransactionEntity() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.categoryId,_that.accountId,_that.frequency,_that.startDate,_that.endDate,_that.nextRunDate,_that.remark,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringTransactionEntity implements RecurringTransactionEntity {
  const _RecurringTransactionEntity({required this.id, required this.type, required this.amount, required this.categoryId, required this.accountId, required this.frequency, required this.startDate, this.endDate, this.nextRunDate, this.remark, this.isActive = true});
  

@override final  String id;
@override final  TransactionType type;
@override final  MoneyAmount amount;
@override final  String categoryId;
@override final  String accountId;
@override final  RecurrenceFrequency frequency;
@override final  DateTime startDate;
@override final  DateTime? endDate;
@override final  DateTime? nextRunDate;
@override final  String? remark;
@override@JsonKey() final  bool isActive;

/// Create a copy of RecurringTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringTransactionEntityCopyWith<_RecurringTransactionEntity> get copyWith => __$RecurringTransactionEntityCopyWithImpl<_RecurringTransactionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringTransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.nextRunDate, nextRunDate) || other.nextRunDate == nextRunDate)&&(identical(other.remark, remark) || other.remark == remark)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,amount,categoryId,accountId,frequency,startDate,endDate,nextRunDate,remark,isActive);

@override
String toString() {
  return 'RecurringTransactionEntity(id: $id, type: $type, amount: $amount, categoryId: $categoryId, accountId: $accountId, frequency: $frequency, startDate: $startDate, endDate: $endDate, nextRunDate: $nextRunDate, remark: $remark, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$RecurringTransactionEntityCopyWith<$Res> implements $RecurringTransactionEntityCopyWith<$Res> {
  factory _$RecurringTransactionEntityCopyWith(_RecurringTransactionEntity value, $Res Function(_RecurringTransactionEntity) _then) = __$RecurringTransactionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type, MoneyAmount amount, String categoryId, String accountId, RecurrenceFrequency frequency, DateTime startDate, DateTime? endDate, DateTime? nextRunDate, String? remark, bool isActive
});




}
/// @nodoc
class __$RecurringTransactionEntityCopyWithImpl<$Res>
    implements _$RecurringTransactionEntityCopyWith<$Res> {
  __$RecurringTransactionEntityCopyWithImpl(this._self, this._then);

  final _RecurringTransactionEntity _self;
  final $Res Function(_RecurringTransactionEntity) _then;

/// Create a copy of RecurringTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? categoryId = null,Object? accountId = null,Object? frequency = null,Object? startDate = null,Object? endDate = freezed,Object? nextRunDate = freezed,Object? remark = freezed,Object? isActive = null,}) {
  return _then(_RecurringTransactionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as MoneyAmount,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurrenceFrequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextRunDate: freezed == nextRunDate ? _self.nextRunDate : nextRunDate // ignore: cast_nullable_to_non_nullable
as DateTime?,remark: freezed == remark ? _self.remark : remark // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
