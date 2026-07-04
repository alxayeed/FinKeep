// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_aggregate_stats_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardAggregateStatsEntity {

 double get totalIncome; double get totalExpense; double get netSavings; double get savingsRate; double get monthlyBudget; double get totalGivenDue; double get totalReceivedDue; double get totalInvested; double get totalInvestmentProfit;
/// Create a copy of DashboardAggregateStatsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardAggregateStatsEntityCopyWith<DashboardAggregateStatsEntity> get copyWith => _$DashboardAggregateStatsEntityCopyWithImpl<DashboardAggregateStatsEntity>(this as DashboardAggregateStatsEntity, _$identity);

  /// Serializes this DashboardAggregateStatsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardAggregateStatsEntity&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netSavings, netSavings) || other.netSavings == netSavings)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.totalGivenDue, totalGivenDue) || other.totalGivenDue == totalGivenDue)&&(identical(other.totalReceivedDue, totalReceivedDue) || other.totalReceivedDue == totalReceivedDue)&&(identical(other.totalInvested, totalInvested) || other.totalInvested == totalInvested)&&(identical(other.totalInvestmentProfit, totalInvestmentProfit) || other.totalInvestmentProfit == totalInvestmentProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netSavings,savingsRate,monthlyBudget,totalGivenDue,totalReceivedDue,totalInvested,totalInvestmentProfit);

@override
String toString() {
  return 'DashboardAggregateStatsEntity(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, savingsRate: $savingsRate, monthlyBudget: $monthlyBudget, totalGivenDue: $totalGivenDue, totalReceivedDue: $totalReceivedDue, totalInvested: $totalInvested, totalInvestmentProfit: $totalInvestmentProfit)';
}


}

/// @nodoc
abstract mixin class $DashboardAggregateStatsEntityCopyWith<$Res>  {
  factory $DashboardAggregateStatsEntityCopyWith(DashboardAggregateStatsEntity value, $Res Function(DashboardAggregateStatsEntity) _then) = _$DashboardAggregateStatsEntityCopyWithImpl;
@useResult
$Res call({
 double totalIncome, double totalExpense, double netSavings, double savingsRate, double monthlyBudget, double totalGivenDue, double totalReceivedDue, double totalInvested, double totalInvestmentProfit
});




}
/// @nodoc
class _$DashboardAggregateStatsEntityCopyWithImpl<$Res>
    implements $DashboardAggregateStatsEntityCopyWith<$Res> {
  _$DashboardAggregateStatsEntityCopyWithImpl(this._self, this._then);

  final DashboardAggregateStatsEntity _self;
  final $Res Function(DashboardAggregateStatsEntity) _then;

/// Create a copy of DashboardAggregateStatsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? netSavings = null,Object? savingsRate = null,Object? monthlyBudget = null,Object? totalGivenDue = null,Object? totalReceivedDue = null,Object? totalInvested = null,Object? totalInvestmentProfit = null,}) {
  return _then(_self.copyWith(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,netSavings: null == netSavings ? _self.netSavings : netSavings // ignore: cast_nullable_to_non_nullable
as double,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as double,monthlyBudget: null == monthlyBudget ? _self.monthlyBudget : monthlyBudget // ignore: cast_nullable_to_non_nullable
as double,totalGivenDue: null == totalGivenDue ? _self.totalGivenDue : totalGivenDue // ignore: cast_nullable_to_non_nullable
as double,totalReceivedDue: null == totalReceivedDue ? _self.totalReceivedDue : totalReceivedDue // ignore: cast_nullable_to_non_nullable
as double,totalInvested: null == totalInvested ? _self.totalInvested : totalInvested // ignore: cast_nullable_to_non_nullable
as double,totalInvestmentProfit: null == totalInvestmentProfit ? _self.totalInvestmentProfit : totalInvestmentProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardAggregateStatsEntity].
extension DashboardAggregateStatsEntityPatterns on DashboardAggregateStatsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardAggregateStatsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardAggregateStatsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardAggregateStatsEntity value)  $default,){
final _that = this;
switch (_that) {
case _DashboardAggregateStatsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardAggregateStatsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardAggregateStatsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalIncome,  double totalExpense,  double netSavings,  double savingsRate,  double monthlyBudget,  double totalGivenDue,  double totalReceivedDue,  double totalInvested,  double totalInvestmentProfit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardAggregateStatsEntity() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.netSavings,_that.savingsRate,_that.monthlyBudget,_that.totalGivenDue,_that.totalReceivedDue,_that.totalInvested,_that.totalInvestmentProfit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalIncome,  double totalExpense,  double netSavings,  double savingsRate,  double monthlyBudget,  double totalGivenDue,  double totalReceivedDue,  double totalInvested,  double totalInvestmentProfit)  $default,) {final _that = this;
switch (_that) {
case _DashboardAggregateStatsEntity():
return $default(_that.totalIncome,_that.totalExpense,_that.netSavings,_that.savingsRate,_that.monthlyBudget,_that.totalGivenDue,_that.totalReceivedDue,_that.totalInvested,_that.totalInvestmentProfit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalIncome,  double totalExpense,  double netSavings,  double savingsRate,  double monthlyBudget,  double totalGivenDue,  double totalReceivedDue,  double totalInvested,  double totalInvestmentProfit)?  $default,) {final _that = this;
switch (_that) {
case _DashboardAggregateStatsEntity() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.netSavings,_that.savingsRate,_that.monthlyBudget,_that.totalGivenDue,_that.totalReceivedDue,_that.totalInvested,_that.totalInvestmentProfit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardAggregateStatsEntity implements DashboardAggregateStatsEntity {
  const _DashboardAggregateStatsEntity({required this.totalIncome, required this.totalExpense, required this.netSavings, required this.savingsRate, required this.monthlyBudget, required this.totalGivenDue, required this.totalReceivedDue, required this.totalInvested, required this.totalInvestmentProfit});
  factory _DashboardAggregateStatsEntity.fromJson(Map<String, dynamic> json) => _$DashboardAggregateStatsEntityFromJson(json);

@override final  double totalIncome;
@override final  double totalExpense;
@override final  double netSavings;
@override final  double savingsRate;
@override final  double monthlyBudget;
@override final  double totalGivenDue;
@override final  double totalReceivedDue;
@override final  double totalInvested;
@override final  double totalInvestmentProfit;

/// Create a copy of DashboardAggregateStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardAggregateStatsEntityCopyWith<_DashboardAggregateStatsEntity> get copyWith => __$DashboardAggregateStatsEntityCopyWithImpl<_DashboardAggregateStatsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardAggregateStatsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardAggregateStatsEntity&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netSavings, netSavings) || other.netSavings == netSavings)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.totalGivenDue, totalGivenDue) || other.totalGivenDue == totalGivenDue)&&(identical(other.totalReceivedDue, totalReceivedDue) || other.totalReceivedDue == totalReceivedDue)&&(identical(other.totalInvested, totalInvested) || other.totalInvested == totalInvested)&&(identical(other.totalInvestmentProfit, totalInvestmentProfit) || other.totalInvestmentProfit == totalInvestmentProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netSavings,savingsRate,monthlyBudget,totalGivenDue,totalReceivedDue,totalInvested,totalInvestmentProfit);

@override
String toString() {
  return 'DashboardAggregateStatsEntity(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, savingsRate: $savingsRate, monthlyBudget: $monthlyBudget, totalGivenDue: $totalGivenDue, totalReceivedDue: $totalReceivedDue, totalInvested: $totalInvested, totalInvestmentProfit: $totalInvestmentProfit)';
}


}

/// @nodoc
abstract mixin class _$DashboardAggregateStatsEntityCopyWith<$Res> implements $DashboardAggregateStatsEntityCopyWith<$Res> {
  factory _$DashboardAggregateStatsEntityCopyWith(_DashboardAggregateStatsEntity value, $Res Function(_DashboardAggregateStatsEntity) _then) = __$DashboardAggregateStatsEntityCopyWithImpl;
@override @useResult
$Res call({
 double totalIncome, double totalExpense, double netSavings, double savingsRate, double monthlyBudget, double totalGivenDue, double totalReceivedDue, double totalInvested, double totalInvestmentProfit
});




}
/// @nodoc
class __$DashboardAggregateStatsEntityCopyWithImpl<$Res>
    implements _$DashboardAggregateStatsEntityCopyWith<$Res> {
  __$DashboardAggregateStatsEntityCopyWithImpl(this._self, this._then);

  final _DashboardAggregateStatsEntity _self;
  final $Res Function(_DashboardAggregateStatsEntity) _then;

/// Create a copy of DashboardAggregateStatsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? netSavings = null,Object? savingsRate = null,Object? monthlyBudget = null,Object? totalGivenDue = null,Object? totalReceivedDue = null,Object? totalInvested = null,Object? totalInvestmentProfit = null,}) {
  return _then(_DashboardAggregateStatsEntity(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,netSavings: null == netSavings ? _self.netSavings : netSavings // ignore: cast_nullable_to_non_nullable
as double,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as double,monthlyBudget: null == monthlyBudget ? _self.monthlyBudget : monthlyBudget // ignore: cast_nullable_to_non_nullable
as double,totalGivenDue: null == totalGivenDue ? _self.totalGivenDue : totalGivenDue // ignore: cast_nullable_to_non_nullable
as double,totalReceivedDue: null == totalReceivedDue ? _self.totalReceivedDue : totalReceivedDue // ignore: cast_nullable_to_non_nullable
as double,totalInvested: null == totalInvested ? _self.totalInvested : totalInvested // ignore: cast_nullable_to_non_nullable
as double,totalInvestmentProfit: null == totalInvestmentProfit ? _self.totalInvestmentProfit : totalInvestmentProfit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
