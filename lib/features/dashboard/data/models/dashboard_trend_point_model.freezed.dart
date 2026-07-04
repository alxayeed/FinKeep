// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_trend_point_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardTrendPointModel {

 DateTime get date; double get income; double get expense; double get balance;
/// Create a copy of DashboardTrendPointModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardTrendPointModelCopyWith<DashboardTrendPointModel> get copyWith => _$DashboardTrendPointModelCopyWithImpl<DashboardTrendPointModel>(this as DashboardTrendPointModel, _$identity);

  /// Serializes this DashboardTrendPointModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardTrendPointModel&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,expense,balance);

@override
String toString() {
  return 'DashboardTrendPointModel(date: $date, income: $income, expense: $expense, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $DashboardTrendPointModelCopyWith<$Res>  {
  factory $DashboardTrendPointModelCopyWith(DashboardTrendPointModel value, $Res Function(DashboardTrendPointModel) _then) = _$DashboardTrendPointModelCopyWithImpl;
@useResult
$Res call({
 DateTime date, double income, double expense, double balance
});




}
/// @nodoc
class _$DashboardTrendPointModelCopyWithImpl<$Res>
    implements $DashboardTrendPointModelCopyWith<$Res> {
  _$DashboardTrendPointModelCopyWithImpl(this._self, this._then);

  final DashboardTrendPointModel _self;
  final $Res Function(DashboardTrendPointModel) _then;

/// Create a copy of DashboardTrendPointModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? income = null,Object? expense = null,Object? balance = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardTrendPointModel].
extension DashboardTrendPointModelPatterns on DashboardTrendPointModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardTrendPointModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardTrendPointModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardTrendPointModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardTrendPointModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardTrendPointModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardTrendPointModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double income,  double expense,  double balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardTrendPointModel() when $default != null:
return $default(_that.date,_that.income,_that.expense,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double income,  double expense,  double balance)  $default,) {final _that = this;
switch (_that) {
case _DashboardTrendPointModel():
return $default(_that.date,_that.income,_that.expense,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double income,  double expense,  double balance)?  $default,) {final _that = this;
switch (_that) {
case _DashboardTrendPointModel() when $default != null:
return $default(_that.date,_that.income,_that.expense,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardTrendPointModel extends DashboardTrendPointModel {
  const _DashboardTrendPointModel({required this.date, required this.income, required this.expense, required this.balance}): super._();
  factory _DashboardTrendPointModel.fromJson(Map<String, dynamic> json) => _$DashboardTrendPointModelFromJson(json);

@override final  DateTime date;
@override final  double income;
@override final  double expense;
@override final  double balance;

/// Create a copy of DashboardTrendPointModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardTrendPointModelCopyWith<_DashboardTrendPointModel> get copyWith => __$DashboardTrendPointModelCopyWithImpl<_DashboardTrendPointModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardTrendPointModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardTrendPointModel&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,expense,balance);

@override
String toString() {
  return 'DashboardTrendPointModel(date: $date, income: $income, expense: $expense, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$DashboardTrendPointModelCopyWith<$Res> implements $DashboardTrendPointModelCopyWith<$Res> {
  factory _$DashboardTrendPointModelCopyWith(_DashboardTrendPointModel value, $Res Function(_DashboardTrendPointModel) _then) = __$DashboardTrendPointModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double income, double expense, double balance
});




}
/// @nodoc
class __$DashboardTrendPointModelCopyWithImpl<$Res>
    implements _$DashboardTrendPointModelCopyWith<$Res> {
  __$DashboardTrendPointModelCopyWithImpl(this._self, this._then);

  final _DashboardTrendPointModel _self;
  final $Res Function(_DashboardTrendPointModel) _then;

/// Create a copy of DashboardTrendPointModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? income = null,Object? expense = null,Object? balance = null,}) {
  return _then(_DashboardTrendPointModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
