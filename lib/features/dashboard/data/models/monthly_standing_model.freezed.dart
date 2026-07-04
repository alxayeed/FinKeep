// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_standing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyStandingModel {

 DateTime get month; double get totalIncome; double get totalExpense; double get totalLendGiven; double get totalLendTaken;
/// Create a copy of MonthlyStandingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyStandingModelCopyWith<MonthlyStandingModel> get copyWith => _$MonthlyStandingModelCopyWithImpl<MonthlyStandingModel>(this as MonthlyStandingModel, _$identity);

  /// Serializes this MonthlyStandingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyStandingModel&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.totalLendGiven, totalLendGiven) || other.totalLendGiven == totalLendGiven)&&(identical(other.totalLendTaken, totalLendTaken) || other.totalLendTaken == totalLendTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,totalIncome,totalExpense,totalLendGiven,totalLendTaken);

@override
String toString() {
  return 'MonthlyStandingModel(month: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, totalLendGiven: $totalLendGiven, totalLendTaken: $totalLendTaken)';
}


}

/// @nodoc
abstract mixin class $MonthlyStandingModelCopyWith<$Res>  {
  factory $MonthlyStandingModelCopyWith(MonthlyStandingModel value, $Res Function(MonthlyStandingModel) _then) = _$MonthlyStandingModelCopyWithImpl;
@useResult
$Res call({
 DateTime month, double totalIncome, double totalExpense, double totalLendGiven, double totalLendTaken
});




}
/// @nodoc
class _$MonthlyStandingModelCopyWithImpl<$Res>
    implements $MonthlyStandingModelCopyWith<$Res> {
  _$MonthlyStandingModelCopyWithImpl(this._self, this._then);

  final MonthlyStandingModel _self;
  final $Res Function(MonthlyStandingModel) _then;

/// Create a copy of MonthlyStandingModel
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


/// Adds pattern-matching-related methods to [MonthlyStandingModel].
extension MonthlyStandingModelPatterns on MonthlyStandingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyStandingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyStandingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyStandingModel value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyStandingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyStandingModel value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyStandingModel() when $default != null:
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
case _MonthlyStandingModel() when $default != null:
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
case _MonthlyStandingModel():
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
case _MonthlyStandingModel() when $default != null:
return $default(_that.month,_that.totalIncome,_that.totalExpense,_that.totalLendGiven,_that.totalLendTaken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyStandingModel extends MonthlyStandingModel {
  const _MonthlyStandingModel({required this.month, required this.totalIncome, required this.totalExpense, required this.totalLendGiven, required this.totalLendTaken}): super._();
  factory _MonthlyStandingModel.fromJson(Map<String, dynamic> json) => _$MonthlyStandingModelFromJson(json);

@override final  DateTime month;
@override final  double totalIncome;
@override final  double totalExpense;
@override final  double totalLendGiven;
@override final  double totalLendTaken;

/// Create a copy of MonthlyStandingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyStandingModelCopyWith<_MonthlyStandingModel> get copyWith => __$MonthlyStandingModelCopyWithImpl<_MonthlyStandingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyStandingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyStandingModel&&(identical(other.month, month) || other.month == month)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.totalLendGiven, totalLendGiven) || other.totalLendGiven == totalLendGiven)&&(identical(other.totalLendTaken, totalLendTaken) || other.totalLendTaken == totalLendTaken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,totalIncome,totalExpense,totalLendGiven,totalLendTaken);

@override
String toString() {
  return 'MonthlyStandingModel(month: $month, totalIncome: $totalIncome, totalExpense: $totalExpense, totalLendGiven: $totalLendGiven, totalLendTaken: $totalLendTaken)';
}


}

/// @nodoc
abstract mixin class _$MonthlyStandingModelCopyWith<$Res> implements $MonthlyStandingModelCopyWith<$Res> {
  factory _$MonthlyStandingModelCopyWith(_MonthlyStandingModel value, $Res Function(_MonthlyStandingModel) _then) = __$MonthlyStandingModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, double totalIncome, double totalExpense, double totalLendGiven, double totalLendTaken
});




}
/// @nodoc
class __$MonthlyStandingModelCopyWithImpl<$Res>
    implements _$MonthlyStandingModelCopyWith<$Res> {
  __$MonthlyStandingModelCopyWithImpl(this._self, this._then);

  final _MonthlyStandingModel _self;
  final $Res Function(_MonthlyStandingModel) _then;

/// Create a copy of MonthlyStandingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? totalIncome = null,Object? totalExpense = null,Object? totalLendGiven = null,Object? totalLendTaken = null,}) {
  return _then(_MonthlyStandingModel(
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
