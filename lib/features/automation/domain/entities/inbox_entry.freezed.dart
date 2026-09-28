// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbox_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InboxEntry {

 String get id; int get amountMinor; TransactionType get type; String get currency; String? get merchant; String? get categoryName; String? get accountName; String? get fromAccountName; String? get toAccountName; String? get remark; DateTime? get date; String? get source; String? get platform; String? get externalTransactionId; DateTime? get createdAt;
/// Create a copy of InboxEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxEntryCopyWith<InboxEntry> get copyWith => _$InboxEntryCopyWithImpl<InboxEntry>(this as InboxEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.fromAccountName, fromAccountName) || other.fromAccountName == fromAccountName)&&(identical(other.toAccountName, toAccountName) || other.toAccountName == toAccountName)&&(identical(other.remark, remark) || other.remark == remark)&&(identical(other.date, date) || other.date == date)&&(identical(other.source, source) || other.source == source)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.externalTransactionId, externalTransactionId) || other.externalTransactionId == externalTransactionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,amountMinor,type,currency,merchant,categoryName,accountName,fromAccountName,toAccountName,remark,date,source,platform,externalTransactionId,createdAt);

@override
String toString() {
  return 'InboxEntry(id: $id, amountMinor: $amountMinor, type: $type, currency: $currency, merchant: $merchant, categoryName: $categoryName, accountName: $accountName, fromAccountName: $fromAccountName, toAccountName: $toAccountName, remark: $remark, date: $date, source: $source, platform: $platform, externalTransactionId: $externalTransactionId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InboxEntryCopyWith<$Res>  {
  factory $InboxEntryCopyWith(InboxEntry value, $Res Function(InboxEntry) _then) = _$InboxEntryCopyWithImpl;
@useResult
$Res call({
 String id, int amountMinor, TransactionType type, String currency, String? merchant, String? categoryName, String? accountName, String? fromAccountName, String? toAccountName, String? remark, DateTime? date, String? source, String? platform, String? externalTransactionId, DateTime? createdAt
});




}
/// @nodoc
class _$InboxEntryCopyWithImpl<$Res>
    implements $InboxEntryCopyWith<$Res> {
  _$InboxEntryCopyWithImpl(this._self, this._then);

  final InboxEntry _self;
  final $Res Function(InboxEntry) _then;

/// Create a copy of InboxEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amountMinor = null,Object? type = null,Object? currency = null,Object? merchant = freezed,Object? categoryName = freezed,Object? accountName = freezed,Object? fromAccountName = freezed,Object? toAccountName = freezed,Object? remark = freezed,Object? date = freezed,Object? source = freezed,Object? platform = freezed,Object? externalTransactionId = freezed,Object? createdAt = freezed,}) {
  return _then(InboxEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,fromAccountName: freezed == fromAccountName ? _self.fromAccountName : fromAccountName // ignore: cast_nullable_to_non_nullable
as String?,toAccountName: freezed == toAccountName ? _self.toAccountName : toAccountName // ignore: cast_nullable_to_non_nullable
as String?,remark: freezed == remark ? _self.remark : remark // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,externalTransactionId: freezed == externalTransactionId ? _self.externalTransactionId : externalTransactionId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxEntry].
extension InboxEntryPatterns on InboxEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxEntry value)  $default,){
final _that = this;
switch (_that) {
case _InboxEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxEntry value)?  $default,){
final _that = this;
switch (_that) {
case _InboxEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int amountMinor,  TransactionType type,  String currency,  String? merchant,  String? categoryName,  String? accountName,  String? fromAccountName,  String? toAccountName,  String? remark,  DateTime? date,  String? source,  String? platform,  String? externalTransactionId,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxEntry() when $default != null:
return $default(_that.id,_that.amountMinor,_that.type,_that.currency,_that.merchant,_that.categoryName,_that.accountName,_that.fromAccountName,_that.toAccountName,_that.remark,_that.date,_that.source,_that.platform,_that.externalTransactionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int amountMinor,  TransactionType type,  String currency,  String? merchant,  String? categoryName,  String? accountName,  String? fromAccountName,  String? toAccountName,  String? remark,  DateTime? date,  String? source,  String? platform,  String? externalTransactionId,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _InboxEntry():
return $default(_that.id,_that.amountMinor,_that.type,_that.currency,_that.merchant,_that.categoryName,_that.accountName,_that.fromAccountName,_that.toAccountName,_that.remark,_that.date,_that.source,_that.platform,_that.externalTransactionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int amountMinor,  TransactionType type,  String currency,  String? merchant,  String? categoryName,  String? accountName,  String? fromAccountName,  String? toAccountName,  String? remark,  DateTime? date,  String? source,  String? platform,  String? externalTransactionId,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InboxEntry() when $default != null:
return $default(_that.id,_that.amountMinor,_that.type,_that.currency,_that.merchant,_that.categoryName,_that.accountName,_that.fromAccountName,_that.toAccountName,_that.remark,_that.date,_that.source,_that.platform,_that.externalTransactionId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _InboxEntry implements InboxEntry {
  const _InboxEntry({required this.id, required this.amountMinor, required this.type, this.currency = 'INR', this.merchant, this.categoryName, this.accountName, this.fromAccountName, this.toAccountName, this.remark, this.date, this.source, this.platform, this.externalTransactionId, this.createdAt});
  

@override final  String id;
@override final  int amountMinor;
@override final  TransactionType type;
@override@JsonKey() final  String currency;
@override final  String? merchant;
@override final  String? categoryName;
@override final  String? accountName;
@override final  String? fromAccountName;
@override final  String? toAccountName;
@override final  String? remark;
@override final  DateTime? date;
@override final  String? source;
@override final  String? platform;
@override final  String? externalTransactionId;
@override final  DateTime? createdAt;

/// Create a copy of InboxEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxEntryCopyWith<_InboxEntry> get copyWith => __$InboxEntryCopyWithImpl<_InboxEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.amountMinor, amountMinor) || other.amountMinor == amountMinor)&&(identical(other.type, type) || other.type == type)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.fromAccountName, fromAccountName) || other.fromAccountName == fromAccountName)&&(identical(other.toAccountName, toAccountName) || other.toAccountName == toAccountName)&&(identical(other.remark, remark) || other.remark == remark)&&(identical(other.date, date) || other.date == date)&&(identical(other.source, source) || other.source == source)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.externalTransactionId, externalTransactionId) || other.externalTransactionId == externalTransactionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,amountMinor,type,currency,merchant,categoryName,accountName,fromAccountName,toAccountName,remark,date,source,platform,externalTransactionId,createdAt);

@override
String toString() {
  return 'InboxEntry(id: $id, amountMinor: $amountMinor, type: $type, currency: $currency, merchant: $merchant, categoryName: $categoryName, accountName: $accountName, fromAccountName: $fromAccountName, toAccountName: $toAccountName, remark: $remark, date: $date, source: $source, platform: $platform, externalTransactionId: $externalTransactionId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InboxEntryCopyWith<$Res> implements $InboxEntryCopyWith<$Res> {
  factory _$InboxEntryCopyWith(_InboxEntry value, $Res Function(_InboxEntry) _then) = __$InboxEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, int amountMinor, TransactionType type, String currency, String? merchant, String? categoryName, String? accountName, String? fromAccountName, String? toAccountName, String? remark, DateTime? date, String? source, String? platform, String? externalTransactionId, DateTime? createdAt
});




}
/// @nodoc
class __$InboxEntryCopyWithImpl<$Res>
    implements _$InboxEntryCopyWith<$Res> {
  __$InboxEntryCopyWithImpl(this._self, this._then);

  final _InboxEntry _self;
  final $Res Function(_InboxEntry) _then;

/// Create a copy of InboxEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amountMinor = null,Object? type = null,Object? currency = null,Object? merchant = freezed,Object? categoryName = freezed,Object? accountName = freezed,Object? fromAccountName = freezed,Object? toAccountName = freezed,Object? remark = freezed,Object? date = freezed,Object? source = freezed,Object? platform = freezed,Object? externalTransactionId = freezed,Object? createdAt = freezed,}) {
  return _then(_InboxEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amountMinor: null == amountMinor ? _self.amountMinor : amountMinor // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,accountName: freezed == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String?,fromAccountName: freezed == fromAccountName ? _self.fromAccountName : fromAccountName // ignore: cast_nullable_to_non_nullable
as String?,toAccountName: freezed == toAccountName ? _self.toAccountName : toAccountName // ignore: cast_nullable_to_non_nullable
as String?,remark: freezed == remark ? _self.remark : remark // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,externalTransactionId: freezed == externalTransactionId ? _self.externalTransactionId : externalTransactionId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
