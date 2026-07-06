// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repayment_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RepaymentEntity {

 String get id; String get lendingId; double get amount; DateTime get paidDate; String? get notes; PaymentType get paymentMethod;
/// Create a copy of RepaymentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepaymentEntityCopyWith<RepaymentEntity> get copyWith => _$RepaymentEntityCopyWithImpl<RepaymentEntity>(this as RepaymentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RepaymentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.lendingId, lendingId) || other.lendingId == lendingId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}


@override
int get hashCode => Object.hash(runtimeType,id,lendingId,amount,paidDate,notes,paymentMethod);

@override
String toString() {
  return 'RepaymentEntity(id: $id, lendingId: $lendingId, amount: $amount, paidDate: $paidDate, notes: $notes, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class $RepaymentEntityCopyWith<$Res>  {
  factory $RepaymentEntityCopyWith(RepaymentEntity value, $Res Function(RepaymentEntity) _then) = _$RepaymentEntityCopyWithImpl;
@useResult
$Res call({
 String id, String lendingId, double amount, DateTime paidDate, String? notes, PaymentType paymentMethod
});




}
/// @nodoc
class _$RepaymentEntityCopyWithImpl<$Res>
    implements $RepaymentEntityCopyWith<$Res> {
  _$RepaymentEntityCopyWithImpl(this._self, this._then);

  final RepaymentEntity _self;
  final $Res Function(RepaymentEntity) _then;

/// Create a copy of RepaymentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? lendingId = null,Object? amount = null,Object? paidDate = null,Object? notes = freezed,Object? paymentMethod = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lendingId: null == lendingId ? _self.lendingId : lendingId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidDate: null == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentType,
  ));
}

}


/// Adds pattern-matching-related methods to [RepaymentEntity].
extension RepaymentEntityPatterns on RepaymentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RepaymentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RepaymentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RepaymentEntity value)  $default,){
final _that = this;
switch (_that) {
case _RepaymentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RepaymentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RepaymentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String lendingId,  double amount,  DateTime paidDate,  String? notes,  PaymentType paymentMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RepaymentEntity() when $default != null:
return $default(_that.id,_that.lendingId,_that.amount,_that.paidDate,_that.notes,_that.paymentMethod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String lendingId,  double amount,  DateTime paidDate,  String? notes,  PaymentType paymentMethod)  $default,) {final _that = this;
switch (_that) {
case _RepaymentEntity():
return $default(_that.id,_that.lendingId,_that.amount,_that.paidDate,_that.notes,_that.paymentMethod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String lendingId,  double amount,  DateTime paidDate,  String? notes,  PaymentType paymentMethod)?  $default,) {final _that = this;
switch (_that) {
case _RepaymentEntity() when $default != null:
return $default(_that.id,_that.lendingId,_that.amount,_that.paidDate,_that.notes,_that.paymentMethod);case _:
  return null;

}
}

}

/// @nodoc


class _RepaymentEntity implements RepaymentEntity {
  const _RepaymentEntity({required this.id, required this.lendingId, required this.amount, required this.paidDate, this.notes, this.paymentMethod = PaymentType.cash});
  

@override final  String id;
@override final  String lendingId;
@override final  double amount;
@override final  DateTime paidDate;
@override final  String? notes;
@override@JsonKey() final  PaymentType paymentMethod;

/// Create a copy of RepaymentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepaymentEntityCopyWith<_RepaymentEntity> get copyWith => __$RepaymentEntityCopyWithImpl<_RepaymentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RepaymentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.lendingId, lendingId) || other.lendingId == lendingId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}


@override
int get hashCode => Object.hash(runtimeType,id,lendingId,amount,paidDate,notes,paymentMethod);

@override
String toString() {
  return 'RepaymentEntity(id: $id, lendingId: $lendingId, amount: $amount, paidDate: $paidDate, notes: $notes, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class _$RepaymentEntityCopyWith<$Res> implements $RepaymentEntityCopyWith<$Res> {
  factory _$RepaymentEntityCopyWith(_RepaymentEntity value, $Res Function(_RepaymentEntity) _then) = __$RepaymentEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String lendingId, double amount, DateTime paidDate, String? notes, PaymentType paymentMethod
});




}
/// @nodoc
class __$RepaymentEntityCopyWithImpl<$Res>
    implements _$RepaymentEntityCopyWith<$Res> {
  __$RepaymentEntityCopyWithImpl(this._self, this._then);

  final _RepaymentEntity _self;
  final $Res Function(_RepaymentEntity) _then;

/// Create a copy of RepaymentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lendingId = null,Object? amount = null,Object? paidDate = null,Object? notes = freezed,Object? paymentMethod = null,}) {
  return _then(_RepaymentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,lendingId: null == lendingId ? _self.lendingId : lendingId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paidDate: null == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentType,
  ));
}


}

// dart format on
