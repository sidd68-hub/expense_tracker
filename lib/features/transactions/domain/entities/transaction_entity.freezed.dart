// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionEntity {

 String get id; TransactionType get type; MoneyAmount get amount; DateTime get date;/// Required for expense/income, null for transfer.
 String? get categoryId;/// Required for expense/income, null for transfer.
 String? get accountId;/// Transfer only.
 String? get fromAccountId;/// Transfer only.
 String? get toAccountId; String? get merchant; String? get remark; TransactionSource get source; bool get isImported; String? get externalTransactionId; String? get automationSource; TransactionStatus get status; bool get isDeleted; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionEntityCopyWith<TransactionEntity> get copyWith => _$TransactionEntityCopyWithImpl<TransactionEntity>(this as TransactionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fromAccountId, fromAccountId) || other.fromAccountId == fromAccountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.remark, remark) || other.remark == remark)&&(identical(other.source, source) || other.source == source)&&(identical(other.isImported, isImported) || other.isImported == isImported)&&(identical(other.externalTransactionId, externalTransactionId) || other.externalTransactionId == externalTransactionId)&&(identical(other.automationSource, automationSource) || other.automationSource == automationSource)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,amount,date,categoryId,accountId,fromAccountId,toAccountId,merchant,remark,source,isImported,externalTransactionId,automationSource,status,isDeleted,createdAt,updatedAt);

@override
String toString() {
  return 'TransactionEntity(id: $id, type: $type, amount: $amount, date: $date, categoryId: $categoryId, accountId: $accountId, fromAccountId: $fromAccountId, toAccountId: $toAccountId, merchant: $merchant, remark: $remark, source: $source, isImported: $isImported, externalTransactionId: $externalTransactionId, automationSource: $automationSource, status: $status, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TransactionEntityCopyWith<$Res>  {
  factory $TransactionEntityCopyWith(TransactionEntity value, $Res Function(TransactionEntity) _then) = _$TransactionEntityCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type, MoneyAmount amount, DateTime date, String? categoryId, String? accountId, String? fromAccountId, String? toAccountId, String? merchant, String? remark, TransactionSource source, bool isImported, String? externalTransactionId, String? automationSource, TransactionStatus status, bool isDeleted, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._self, this._then);

  final TransactionEntity _self;
  final $Res Function(TransactionEntity) _then;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? date = null,Object? categoryId = freezed,Object? accountId = freezed,Object? fromAccountId = freezed,Object? toAccountId = freezed,Object? merchant = freezed,Object? remark = freezed,Object? source = null,Object? isImported = null,Object? externalTransactionId = freezed,Object? automationSource = freezed,Object? status = null,Object? isDeleted = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(TransactionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as MoneyAmount,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,fromAccountId: freezed == fromAccountId ? _self.fromAccountId : fromAccountId // ignore: cast_nullable_to_non_nullable
as String?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,remark: freezed == remark ? _self.remark : remark // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,isImported: null == isImported ? _self.isImported : isImported // ignore: cast_nullable_to_non_nullable
as bool,externalTransactionId: freezed == externalTransactionId ? _self.externalTransactionId : externalTransactionId // ignore: cast_nullable_to_non_nullable
as String?,automationSource: freezed == automationSource ? _self.automationSource : automationSource // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionEntity].
extension TransactionEntityPatterns on TransactionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionEntity value)  $default,){
final _that = this;
switch (_that) {
case _TransactionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionType type,  MoneyAmount amount,  DateTime date,  String? categoryId,  String? accountId,  String? fromAccountId,  String? toAccountId,  String? merchant,  String? remark,  TransactionSource source,  bool isImported,  String? externalTransactionId,  String? automationSource,  TransactionStatus status,  bool isDeleted,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionEntity() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.date,_that.categoryId,_that.accountId,_that.fromAccountId,_that.toAccountId,_that.merchant,_that.remark,_that.source,_that.isImported,_that.externalTransactionId,_that.automationSource,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionType type,  MoneyAmount amount,  DateTime date,  String? categoryId,  String? accountId,  String? fromAccountId,  String? toAccountId,  String? merchant,  String? remark,  TransactionSource source,  bool isImported,  String? externalTransactionId,  String? automationSource,  TransactionStatus status,  bool isDeleted,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionEntity():
return $default(_that.id,_that.type,_that.amount,_that.date,_that.categoryId,_that.accountId,_that.fromAccountId,_that.toAccountId,_that.merchant,_that.remark,_that.source,_that.isImported,_that.externalTransactionId,_that.automationSource,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionType type,  MoneyAmount amount,  DateTime date,  String? categoryId,  String? accountId,  String? fromAccountId,  String? toAccountId,  String? merchant,  String? remark,  TransactionSource source,  bool isImported,  String? externalTransactionId,  String? automationSource,  TransactionStatus status,  bool isDeleted,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionEntity() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.date,_that.categoryId,_that.accountId,_that.fromAccountId,_that.toAccountId,_that.merchant,_that.remark,_that.source,_that.isImported,_that.externalTransactionId,_that.automationSource,_that.status,_that.isDeleted,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionEntity extends TransactionEntity {
  const _TransactionEntity({required this.id, required this.type, required this.amount, required this.date, this.categoryId, this.accountId, this.fromAccountId, this.toAccountId, this.merchant, this.remark, this.source = TransactionSource.manual, this.isImported = false, this.externalTransactionId, this.automationSource, this.status = TransactionStatus.confirmed, this.isDeleted = false, this.createdAt, this.updatedAt}): super._();
  

@override final  String id;
@override final  TransactionType type;
@override final  MoneyAmount amount;
@override final  DateTime date;
/// Required for expense/income, null for transfer.
@override final  String? categoryId;
/// Required for expense/income, null for transfer.
@override final  String? accountId;
/// Transfer only.
@override final  String? fromAccountId;
/// Transfer only.
@override final  String? toAccountId;
@override final  String? merchant;
@override final  String? remark;
@override@JsonKey() final  TransactionSource source;
@override@JsonKey() final  bool isImported;
@override final  String? externalTransactionId;
@override final  String? automationSource;
@override@JsonKey() final  TransactionStatus status;
@override@JsonKey() final  bool isDeleted;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionEntityCopyWith<_TransactionEntity> get copyWith => __$TransactionEntityCopyWithImpl<_TransactionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.fromAccountId, fromAccountId) || other.fromAccountId == fromAccountId)&&(identical(other.toAccountId, toAccountId) || other.toAccountId == toAccountId)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.remark, remark) || other.remark == remark)&&(identical(other.source, source) || other.source == source)&&(identical(other.isImported, isImported) || other.isImported == isImported)&&(identical(other.externalTransactionId, externalTransactionId) || other.externalTransactionId == externalTransactionId)&&(identical(other.automationSource, automationSource) || other.automationSource == automationSource)&&(identical(other.status, status) || other.status == status)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,amount,date,categoryId,accountId,fromAccountId,toAccountId,merchant,remark,source,isImported,externalTransactionId,automationSource,status,isDeleted,createdAt,updatedAt);

@override
String toString() {
  return 'TransactionEntity(id: $id, type: $type, amount: $amount, date: $date, categoryId: $categoryId, accountId: $accountId, fromAccountId: $fromAccountId, toAccountId: $toAccountId, merchant: $merchant, remark: $remark, source: $source, isImported: $isImported, externalTransactionId: $externalTransactionId, automationSource: $automationSource, status: $status, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionEntityCopyWith<$Res> implements $TransactionEntityCopyWith<$Res> {
  factory _$TransactionEntityCopyWith(_TransactionEntity value, $Res Function(_TransactionEntity) _then) = __$TransactionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type, MoneyAmount amount, DateTime date, String? categoryId, String? accountId, String? fromAccountId, String? toAccountId, String? merchant, String? remark, TransactionSource source, bool isImported, String? externalTransactionId, String? automationSource, TransactionStatus status, bool isDeleted, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$TransactionEntityCopyWithImpl<$Res>
    implements _$TransactionEntityCopyWith<$Res> {
  __$TransactionEntityCopyWithImpl(this._self, this._then);

  final _TransactionEntity _self;
  final $Res Function(_TransactionEntity) _then;

/// Create a copy of TransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? date = null,Object? categoryId = freezed,Object? accountId = freezed,Object? fromAccountId = freezed,Object? toAccountId = freezed,Object? merchant = freezed,Object? remark = freezed,Object? source = null,Object? isImported = null,Object? externalTransactionId = freezed,Object? automationSource = freezed,Object? status = null,Object? isDeleted = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TransactionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as MoneyAmount,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,fromAccountId: freezed == fromAccountId ? _self.fromAccountId : fromAccountId // ignore: cast_nullable_to_non_nullable
as String?,toAccountId: freezed == toAccountId ? _self.toAccountId : toAccountId // ignore: cast_nullable_to_non_nullable
as String?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,remark: freezed == remark ? _self.remark : remark // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TransactionSource,isImported: null == isImported ? _self.isImported : isImported // ignore: cast_nullable_to_non_nullable
as bool,externalTransactionId: freezed == externalTransactionId ? _self.externalTransactionId : externalTransactionId // ignore: cast_nullable_to_non_nullable
as String?,automationSource: freezed == automationSource ? _self.automationSource : automationSource // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransactionStatus,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
