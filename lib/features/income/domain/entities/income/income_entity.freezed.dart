// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IncomeEntity {

 String get id; double get amount; String get description; DateTime get date; String get categoryId; PaymentType get paymentMethod; DateTime get createdAt;
/// Create a copy of IncomeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeEntityCopyWith<IncomeEntity> get copyWith => _$IncomeEntityCopyWithImpl<IncomeEntity>(this as IncomeEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,amount,description,date,categoryId,paymentMethod,createdAt);

@override
String toString() {
  return 'IncomeEntity(id: $id, amount: $amount, description: $description, date: $date, categoryId: $categoryId, paymentMethod: $paymentMethod, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $IncomeEntityCopyWith<$Res>  {
  factory $IncomeEntityCopyWith(IncomeEntity value, $Res Function(IncomeEntity) _then) = _$IncomeEntityCopyWithImpl;
@useResult
$Res call({
 String id, double amount, String description, DateTime date, String categoryId, PaymentType paymentMethod, DateTime createdAt
});




}
/// @nodoc
class _$IncomeEntityCopyWithImpl<$Res>
    implements $IncomeEntityCopyWith<$Res> {
  _$IncomeEntityCopyWithImpl(this._self, this._then);

  final IncomeEntity _self;
  final $Res Function(IncomeEntity) _then;

/// Create a copy of IncomeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? description = null,Object? date = null,Object? categoryId = null,Object? paymentMethod = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomeEntity].
extension IncomeEntityPatterns on IncomeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomeEntity value)  $default,){
final _that = this;
switch (_that) {
case _IncomeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _IncomeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double amount,  String description,  DateTime date,  String categoryId,  PaymentType paymentMethod,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomeEntity() when $default != null:
return $default(_that.id,_that.amount,_that.description,_that.date,_that.categoryId,_that.paymentMethod,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double amount,  String description,  DateTime date,  String categoryId,  PaymentType paymentMethod,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _IncomeEntity():
return $default(_that.id,_that.amount,_that.description,_that.date,_that.categoryId,_that.paymentMethod,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double amount,  String description,  DateTime date,  String categoryId,  PaymentType paymentMethod,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _IncomeEntity() when $default != null:
return $default(_that.id,_that.amount,_that.description,_that.date,_that.categoryId,_that.paymentMethod,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _IncomeEntity implements IncomeEntity {
  const _IncomeEntity({required this.id, required this.amount, required this.description, required this.date, required this.categoryId, this.paymentMethod = PaymentType.cash, required this.createdAt});
  

@override final  String id;
@override final  double amount;
@override final  String description;
@override final  DateTime date;
@override final  String categoryId;
@override@JsonKey() final  PaymentType paymentMethod;
@override final  DateTime createdAt;

/// Create a copy of IncomeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomeEntityCopyWith<_IncomeEntity> get copyWith => __$IncomeEntityCopyWithImpl<_IncomeEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomeEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,amount,description,date,categoryId,paymentMethod,createdAt);

@override
String toString() {
  return 'IncomeEntity(id: $id, amount: $amount, description: $description, date: $date, categoryId: $categoryId, paymentMethod: $paymentMethod, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$IncomeEntityCopyWith<$Res> implements $IncomeEntityCopyWith<$Res> {
  factory _$IncomeEntityCopyWith(_IncomeEntity value, $Res Function(_IncomeEntity) _then) = __$IncomeEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, double amount, String description, DateTime date, String categoryId, PaymentType paymentMethod, DateTime createdAt
});




}
/// @nodoc
class __$IncomeEntityCopyWithImpl<$Res>
    implements _$IncomeEntityCopyWith<$Res> {
  __$IncomeEntityCopyWithImpl(this._self, this._then);

  final _IncomeEntity _self;
  final $Res Function(_IncomeEntity) _then;

/// Create a copy of IncomeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? description = null,Object? date = null,Object? categoryId = null,Object? paymentMethod = null,Object? createdAt = null,}) {
  return _then(_IncomeEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
