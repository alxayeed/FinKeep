// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_trend_point_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardTrendPointEntity {

 DateTime get date; double get income; double get expense; double get balance;
/// Create a copy of DashboardTrendPointEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardTrendPointEntityCopyWith<DashboardTrendPointEntity> get copyWith => _$DashboardTrendPointEntityCopyWithImpl<DashboardTrendPointEntity>(this as DashboardTrendPointEntity, _$identity);

  /// Serializes this DashboardTrendPointEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardTrendPointEntity&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,expense,balance);

@override
String toString() {
  return 'DashboardTrendPointEntity(date: $date, income: $income, expense: $expense, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $DashboardTrendPointEntityCopyWith<$Res>  {
  factory $DashboardTrendPointEntityCopyWith(DashboardTrendPointEntity value, $Res Function(DashboardTrendPointEntity) _then) = _$DashboardTrendPointEntityCopyWithImpl;
@useResult
$Res call({
 DateTime date, double income, double expense, double balance
});




}
/// @nodoc
class _$DashboardTrendPointEntityCopyWithImpl<$Res>
    implements $DashboardTrendPointEntityCopyWith<$Res> {
  _$DashboardTrendPointEntityCopyWithImpl(this._self, this._then);

  final DashboardTrendPointEntity _self;
  final $Res Function(DashboardTrendPointEntity) _then;

/// Create a copy of DashboardTrendPointEntity
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


/// Adds pattern-matching-related methods to [DashboardTrendPointEntity].
extension DashboardTrendPointEntityPatterns on DashboardTrendPointEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardTrendPointEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardTrendPointEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardTrendPointEntity value)  $default,){
final _that = this;
switch (_that) {
case _DashboardTrendPointEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardTrendPointEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardTrendPointEntity() when $default != null:
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
case _DashboardTrendPointEntity() when $default != null:
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
case _DashboardTrendPointEntity():
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
case _DashboardTrendPointEntity() when $default != null:
return $default(_that.date,_that.income,_that.expense,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardTrendPointEntity implements DashboardTrendPointEntity {
  const _DashboardTrendPointEntity({required this.date, required this.income, required this.expense, required this.balance});
  factory _DashboardTrendPointEntity.fromJson(Map<String, dynamic> json) => _$DashboardTrendPointEntityFromJson(json);

@override final  DateTime date;
@override final  double income;
@override final  double expense;
@override final  double balance;

/// Create a copy of DashboardTrendPointEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardTrendPointEntityCopyWith<_DashboardTrendPointEntity> get copyWith => __$DashboardTrendPointEntityCopyWithImpl<_DashboardTrendPointEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardTrendPointEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardTrendPointEntity&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,expense,balance);

@override
String toString() {
  return 'DashboardTrendPointEntity(date: $date, income: $income, expense: $expense, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$DashboardTrendPointEntityCopyWith<$Res> implements $DashboardTrendPointEntityCopyWith<$Res> {
  factory _$DashboardTrendPointEntityCopyWith(_DashboardTrendPointEntity value, $Res Function(_DashboardTrendPointEntity) _then) = __$DashboardTrendPointEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double income, double expense, double balance
});




}
/// @nodoc
class __$DashboardTrendPointEntityCopyWithImpl<$Res>
    implements _$DashboardTrendPointEntityCopyWith<$Res> {
  __$DashboardTrendPointEntityCopyWithImpl(this._self, this._then);

  final _DashboardTrendPointEntity _self;
  final $Res Function(_DashboardTrendPointEntity) _then;

/// Create a copy of DashboardTrendPointEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? income = null,Object? expense = null,Object? balance = null,}) {
  return _then(_DashboardTrendPointEntity(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
