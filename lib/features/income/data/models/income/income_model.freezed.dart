// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IncomeModel {

 String get id; double get amount; String get description;@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime get date; String get categoryId; PaymentType get paymentMethod;@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime get createdAt;
/// Create a copy of IncomeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeModelCopyWith<IncomeModel> get copyWith => _$IncomeModelCopyWithImpl<IncomeModel>(this as IncomeModel, _$identity);

  /// Serializes this IncomeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,description,date,categoryId,paymentMethod,createdAt);

@override
String toString() {
  return 'IncomeModel(id: $id, amount: $amount, description: $description, date: $date, categoryId: $categoryId, paymentMethod: $paymentMethod, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $IncomeModelCopyWith<$Res>  {
  factory $IncomeModelCopyWith(IncomeModel value, $Res Function(IncomeModel) _then) = _$IncomeModelCopyWithImpl;
@useResult
$Res call({
 String id, double amount, String description,@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime date, String categoryId, PaymentType paymentMethod,@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime createdAt
});




}
/// @nodoc
class _$IncomeModelCopyWithImpl<$Res>
    implements $IncomeModelCopyWith<$Res> {
  _$IncomeModelCopyWithImpl(this._self, this._then);

  final IncomeModel _self;
  final $Res Function(IncomeModel) _then;

/// Create a copy of IncomeModel
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


/// Adds pattern-matching-related methods to [IncomeModel].
extension IncomeModelPatterns on IncomeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomeModel value)  $default,){
final _that = this;
switch (_that) {
case _IncomeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomeModel value)?  $default,){
final _that = this;
switch (_that) {
case _IncomeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double amount,  String description, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime date,  String categoryId,  PaymentType paymentMethod, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomeModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double amount,  String description, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime date,  String categoryId,  PaymentType paymentMethod, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _IncomeModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double amount,  String description, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime date,  String categoryId,  PaymentType paymentMethod, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _IncomeModel() when $default != null:
return $default(_that.id,_that.amount,_that.description,_that.date,_that.categoryId,_that.paymentMethod,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IncomeModel extends IncomeModel {
  const _IncomeModel({required this.id, required this.amount, required this.description, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) required this.date, required this.categoryId, this.paymentMethod = PaymentType.cash, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) required this.createdAt}): super._();
  factory _IncomeModel.fromJson(Map<String, dynamic> json) => _$IncomeModelFromJson(json);

@override final  String id;
@override final  double amount;
@override final  String description;
@override@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) final  DateTime date;
@override final  String categoryId;
@override@JsonKey() final  PaymentType paymentMethod;
@override@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) final  DateTime createdAt;

/// Create a copy of IncomeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomeModelCopyWith<_IncomeModel> get copyWith => __$IncomeModelCopyWithImpl<_IncomeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncomeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,description,date,categoryId,paymentMethod,createdAt);

@override
String toString() {
  return 'IncomeModel(id: $id, amount: $amount, description: $description, date: $date, categoryId: $categoryId, paymentMethod: $paymentMethod, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$IncomeModelCopyWith<$Res> implements $IncomeModelCopyWith<$Res> {
  factory _$IncomeModelCopyWith(_IncomeModel value, $Res Function(_IncomeModel) _then) = __$IncomeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, double amount, String description,@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime date, String categoryId, PaymentType paymentMethod,@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime createdAt
});




}
/// @nodoc
class __$IncomeModelCopyWithImpl<$Res>
    implements _$IncomeModelCopyWith<$Res> {
  __$IncomeModelCopyWithImpl(this._self, this._then);

  final _IncomeModel _self;
  final $Res Function(_IncomeModel) _then;

/// Create a copy of IncomeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? description = null,Object? date = null,Object? categoryId = null,Object? paymentMethod = null,Object? createdAt = null,}) {
  return _then(_IncomeModel(
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
