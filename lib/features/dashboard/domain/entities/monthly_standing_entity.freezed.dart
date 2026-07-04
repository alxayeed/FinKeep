// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_standing_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyStandingEntity {

 DateTime get month; double get totalIncome; double get totalExpense; double get totalLendGiven; double get totalLendTaken;
/// Create a copy of MonthlyStandingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyStandingEntityCopyWith<MonthlyStandingEntity> get copyWith => _$MonthlyStandingEntityCopyWithImpl<MonthlyStandingEntity>(this as MonthlyStandingEntity, _$identity);

  /// Serializes this MonthlyStandingEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyStandingEntity&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.totalLendGiven, totalLendGiven) || other.totalLendGiven == totalLendGiven)&&(identical(other.totalLendTaken, totalLendTaken) || other.totalLendTaken == totalLendTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,totalIncome,totalExpense,totalLendGiven,totalLendTaken);

@override
String toString() {
  return 'MonthlyStandingEntity(month: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, totalLendGiven: $totalLendGiven, totalLendTaken: $totalLendTaken)';
}


}

/// @nodoc
abstract mixin class $MonthlyStandingEntityCopyWith<$Res>  {
  factory $MonthlyStandingEntityCopyWith(MonthlyStandingEntity value, $Res Function(MonthlyStandingEntity) _then) = _$MonthlyStandingEntityCopyWithImpl;
@useResult
$Res call({
 DateTime month, double totalIncome, double totalExpense, double totalLendGiven, double totalLendTaken
});




}
/// @nodoc
class _$MonthlyStandingEntityCopyWithImpl<$Res>
    implements $MonthlyStandingEntityCopyWith<$Res> {
  _$MonthlyStandingEntityCopyWithImpl(this._self, this._then);

  final MonthlyStandingEntity _self;
  final $Res Function(MonthlyStandingEntity) _then;

/// Create a copy of MonthlyStandingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? totalIncome = null,Object? totalExpense = null,Object? totalLendGiven = null,Object? totalLendTaken = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,totalLendGiven: null == totalLendGiven ? _self.totalLendGiven : totalLendGiven // ignore: cast_nullable_to_non_nullable
as double,totalLendTaken: null == totalLendTaken ? _self.totalLendTaken : totalLendTaken // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyStandingEntity].
extension MonthlyStandingEntityPatterns on MonthlyStandingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyStandingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyStandingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyStandingEntity value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyStandingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyStandingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyStandingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  double totalIncome,  double totalExpense,  double totalLendGiven,  double totalLendTaken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyStandingEntity() when $default != null:
return $default(_that.month,_that.totalIncome,_that.totalExpense,_that.totalLendGiven,_that.totalLendTaken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  double totalIncome,  double totalExpense,  double totalLendGiven,  double totalLendTaken)  $default,) {final _that = this;
switch (_that) {
case _MonthlyStandingEntity():
return $default(_that.month,_that.totalIncome,_that.totalExpense,_that.totalLendGiven,_that.totalLendTaken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  double totalIncome,  double totalExpense,  double totalLendGiven,  double totalLendTaken)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyStandingEntity() when $default != null:
return $default(_that.month,_that.totalIncome,_that.totalExpense,_that.totalLendGiven,_that.totalLendTaken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyStandingEntity implements MonthlyStandingEntity {
  const _MonthlyStandingEntity({required this.month, required this.totalIncome, required this.totalExpense, required this.totalLendGiven, required this.totalLendTaken});
  factory _MonthlyStandingEntity.fromJson(Map<String, dynamic> json) => _$MonthlyStandingEntityFromJson(json);

@override final  DateTime month;
@override final  double totalIncome;
@override final  double totalExpense;
@override final  double totalLendGiven;
@override final  double totalLendTaken;

/// Create a copy of MonthlyStandingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyStandingEntityCopyWith<_MonthlyStandingEntity> get copyWith => __$MonthlyStandingEntityCopyWithImpl<_MonthlyStandingEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyStandingEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyStandingEntity&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.totalLendGiven, totalLendGiven) || other.totalLendGiven == totalLendGiven)&&(identical(other.totalLendTaken, totalLendTaken) || other.totalLendTaken == totalLendTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,totalIncome,totalExpense,totalLendGiven,totalLendTaken);

@override
String toString() {
  return 'MonthlyStandingEntity(month: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, totalLendGiven: $totalLendGiven, totalLendTaken: $totalLendTaken)';
}


}

/// @nodoc
abstract mixin class _$MonthlyStandingEntityCopyWith<$Res> implements $MonthlyStandingEntityCopyWith<$Res> {
  factory _$MonthlyStandingEntityCopyWith(_MonthlyStandingEntity value, $Res Function(_MonthlyStandingEntity) _then) = __$MonthlyStandingEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, double totalIncome, double totalExpense, double totalLendGiven, double totalLendTaken
});




}
/// @nodoc
class __$MonthlyStandingEntityCopyWithImpl<$Res>
    implements _$MonthlyStandingEntityCopyWith<$Res> {
  __$MonthlyStandingEntityCopyWithImpl(this._self, this._then);

  final _MonthlyStandingEntity _self;
  final $Res Function(_MonthlyStandingEntity) _then;

/// Create a copy of MonthlyStandingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? totalIncome = null,Object? totalExpense = null,Object? totalLendGiven = null,Object? totalLendTaken = null,}) {
  return _then(_MonthlyStandingEntity(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,totalLendGiven: null == totalLendGiven ? _self.totalLendGiven : totalLendGiven // ignore: cast_nullable_to_non_nullable
as double,totalLendTaken: null == totalLendTaken ? _self.totalLendTaken : totalLendTaken // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
