// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repayment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RepaymentModel {

 String get id; String get lendingId; double get amount;@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime get paidDate; String? get notes; PaymentType get paymentMethod;
/// Create a copy of RepaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepaymentModelCopyWith<RepaymentModel> get copyWith => _$RepaymentModelCopyWithImpl<RepaymentModel>(this as RepaymentModel, _$identity);

  /// Serializes this RepaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RepaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.lendingId, lendingId) || other.lendingId == lendingId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lendingId,amount,paidDate,notes,paymentMethod);

@override
String toString() {
  return 'RepaymentModel(id: $id, lendingId: $lendingId, amount: $amount, paidDate: $paidDate, notes: $notes, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class $RepaymentModelCopyWith<$Res>  {
  factory $RepaymentModelCopyWith(RepaymentModel value, $Res Function(RepaymentModel) _then) = _$RepaymentModelCopyWithImpl;
@useResult
$Res call({
 String id, String lendingId, double amount,@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime paidDate, String? notes, PaymentType paymentMethod
});




}
/// @nodoc
class _$RepaymentModelCopyWithImpl<$Res>
    implements $RepaymentModelCopyWith<$Res> {
  _$RepaymentModelCopyWithImpl(this._self, this._then);

  final RepaymentModel _self;
  final $Res Function(RepaymentModel) _then;

/// Create a copy of RepaymentModel
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


/// Adds pattern-matching-related methods to [RepaymentModel].
extension RepaymentModelPatterns on RepaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RepaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RepaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RepaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _RepaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RepaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _RepaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String lendingId,  double amount, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime paidDate,  String? notes,  PaymentType paymentMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RepaymentModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String lendingId,  double amount, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime paidDate,  String? notes,  PaymentType paymentMethod)  $default,) {final _that = this;
switch (_that) {
case _RepaymentModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String lendingId,  double amount, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime paidDate,  String? notes,  PaymentType paymentMethod)?  $default,) {final _that = this;
switch (_that) {
case _RepaymentModel() when $default != null:
return $default(_that.id,_that.lendingId,_that.amount,_that.paidDate,_that.notes,_that.paymentMethod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RepaymentModel extends RepaymentModel {
  const _RepaymentModel({required this.id, required this.lendingId, required this.amount, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) required this.paidDate, this.notes, this.paymentMethod = PaymentType.cash}): super._();
  factory _RepaymentModel.fromJson(Map<String, dynamic> json) => _$RepaymentModelFromJson(json);

@override final  String id;
@override final  String lendingId;
@override final  double amount;
@override@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) final  DateTime paidDate;
@override final  String? notes;
@override@JsonKey() final  PaymentType paymentMethod;

/// Create a copy of RepaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepaymentModelCopyWith<_RepaymentModel> get copyWith => __$RepaymentModelCopyWithImpl<_RepaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RepaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RepaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.lendingId, lendingId) || other.lendingId == lendingId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,lendingId,amount,paidDate,notes,paymentMethod);

@override
String toString() {
  return 'RepaymentModel(id: $id, lendingId: $lendingId, amount: $amount, paidDate: $paidDate, notes: $notes, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class _$RepaymentModelCopyWith<$Res> implements $RepaymentModelCopyWith<$Res> {
  factory _$RepaymentModelCopyWith(_RepaymentModel value, $Res Function(_RepaymentModel) _then) = __$RepaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String lendingId, double amount,@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime paidDate, String? notes, PaymentType paymentMethod
});




}
/// @nodoc
class __$RepaymentModelCopyWithImpl<$Res>
    implements _$RepaymentModelCopyWith<$Res> {
  __$RepaymentModelCopyWithImpl(this._self, this._then);

  final _RepaymentModel _self;
  final $Res Function(_RepaymentModel) _then;

/// Create a copy of RepaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? lendingId = null,Object? amount = null,Object? paidDate = null,Object? notes = freezed,Object? paymentMethod = null,}) {
  return _then(_RepaymentModel(
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
