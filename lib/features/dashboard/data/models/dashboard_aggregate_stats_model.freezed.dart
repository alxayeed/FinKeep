// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_aggregate_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardAggregateStatsModel {

 double get totalIncome; double get totalExpense; double get netSavings; double get savingsRate; double get monthlyBudget; double get totalGivenDue; double get totalReceivedDue; double get totalInvested; double get totalInvestmentProfit;
/// Create a copy of DashboardAggregateStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardAggregateStatsModelCopyWith<DashboardAggregateStatsModel> get copyWith => _$DashboardAggregateStatsModelCopyWithImpl<DashboardAggregateStatsModel>(this as DashboardAggregateStatsModel, _$identity);

  /// Serializes this DashboardAggregateStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardAggregateStatsModel&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netSavings, netSavings) || other.netSavings == netSavings)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.totalGivenDue, totalGivenDue) || other.totalGivenDue == totalGivenDue)&&(identical(other.totalReceivedDue, totalReceivedDue) || other.totalReceivedDue == totalReceivedDue)&&(identical(other.totalInvested, totalInvested) || other.totalInvested == totalInvested)&&(identical(other.totalInvestmentProfit, totalInvestmentProfit) || other.totalInvestmentProfit == totalInvestmentProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netSavings,savingsRate,monthlyBudget,totalGivenDue,totalReceivedDue,totalInvested,totalInvestmentProfit);

@override
String toString() {
  return 'DashboardAggregateStatsModel(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, savingsRate: $savingsRate, monthlyBudget: $monthlyBudget, totalGivenDue: $totalGivenDue, totalReceivedDue: $totalReceivedDue, totalInvested: $totalInvested, totalInvestmentProfit: $totalInvestmentProfit)';
}


}

/// @nodoc
abstract mixin class $DashboardAggregateStatsModelCopyWith<$Res>  {
  factory $DashboardAggregateStatsModelCopyWith(DashboardAggregateStatsModel value, $Res Function(DashboardAggregateStatsModel) _then) = _$DashboardAggregateStatsModelCopyWithImpl;
@useResult
$Res call({
 double totalIncome, double totalExpense, double netSavings, double savingsRate, double monthlyBudget, double totalGivenDue, double totalReceivedDue, double totalInvested, double totalInvestmentProfit
});




}
/// @nodoc
class _$DashboardAggregateStatsModelCopyWithImpl<$Res>
    implements $DashboardAggregateStatsModelCopyWith<$Res> {
  _$DashboardAggregateStatsModelCopyWithImpl(this._self, this._then);

  final DashboardAggregateStatsModel _self;
  final $Res Function(DashboardAggregateStatsModel) _then;

/// Create a copy of DashboardAggregateStatsModel
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


/// Adds pattern-matching-related methods to [DashboardAggregateStatsModel].
extension DashboardAggregateStatsModelPatterns on DashboardAggregateStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardAggregateStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardAggregateStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardAggregateStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardAggregateStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardAggregateStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardAggregateStatsModel() when $default != null:
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
case _DashboardAggregateStatsModel() when $default != null:
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
case _DashboardAggregateStatsModel():
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
case _DashboardAggregateStatsModel() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.netSavings,_that.savingsRate,_that.monthlyBudget,_that.totalGivenDue,_that.totalReceivedDue,_that.totalInvested,_that.totalInvestmentProfit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardAggregateStatsModel extends DashboardAggregateStatsModel {
  const _DashboardAggregateStatsModel({required this.totalIncome, required this.totalExpense, required this.netSavings, required this.savingsRate, required this.monthlyBudget, required this.totalGivenDue, required this.totalReceivedDue, required this.totalInvested, required this.totalInvestmentProfit}): super._();
  factory _DashboardAggregateStatsModel.fromJson(Map<String, dynamic> json) => _$DashboardAggregateStatsModelFromJson(json);

@override final  double totalIncome;
@override final  double totalExpense;
@override final  double netSavings;
@override final  double savingsRate;
@override final  double monthlyBudget;
@override final  double totalGivenDue;
@override final  double totalReceivedDue;
@override final  double totalInvested;
@override final  double totalInvestmentProfit;

/// Create a copy of DashboardAggregateStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardAggregateStatsModelCopyWith<_DashboardAggregateStatsModel> get copyWith => __$DashboardAggregateStatsModelCopyWithImpl<_DashboardAggregateStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardAggregateStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardAggregateStatsModel&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netSavings, netSavings) || other.netSavings == netSavings)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.totalGivenDue, totalGivenDue) || other.totalGivenDue == totalGivenDue)&&(identical(other.totalReceivedDue, totalReceivedDue) || other.totalReceivedDue == totalReceivedDue)&&(identical(other.totalInvested, totalInvested) || other.totalInvested == totalInvested)&&(identical(other.totalInvestmentProfit, totalInvestmentProfit) || other.totalInvestmentProfit == totalInvestmentProfit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netSavings,savingsRate,monthlyBudget,totalGivenDue,totalReceivedDue,totalInvested,totalInvestmentProfit);

@override
String toString() {
  return 'DashboardAggregateStatsModel(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, savingsRate: $savingsRate, monthlyBudget: $monthlyBudget, totalGivenDue: $totalGivenDue, totalReceivedDue: $totalReceivedDue, totalInvested: $totalInvested, totalInvestmentProfit: $totalInvestmentProfit)';
}


}

/// @nodoc
abstract mixin class _$DashboardAggregateStatsModelCopyWith<$Res> implements $DashboardAggregateStatsModelCopyWith<$Res> {
  factory _$DashboardAggregateStatsModelCopyWith(_DashboardAggregateStatsModel value, $Res Function(_DashboardAggregateStatsModel) _then) = __$DashboardAggregateStatsModelCopyWithImpl;
@override @useResult
$Res call({
 double totalIncome, double totalExpense, double netSavings, double savingsRate, double monthlyBudget, double totalGivenDue, double totalReceivedDue, double totalInvested, double totalInvestmentProfit
});




}
/// @nodoc
class __$DashboardAggregateStatsModelCopyWithImpl<$Res>
    implements _$DashboardAggregateStatsModelCopyWith<$Res> {
  __$DashboardAggregateStatsModelCopyWithImpl(this._self, this._then);

  final _DashboardAggregateStatsModel _self;
  final $Res Function(_DashboardAggregateStatsModel) _then;

/// Create a copy of DashboardAggregateStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? netSavings = null,Object? savingsRate = null,Object? monthlyBudget = null,Object? totalGivenDue = null,Object? totalReceivedDue = null,Object? totalInvested = null,Object? totalInvestmentProfit = null,}) {
  return _then(_DashboardAggregateStatsModel(
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
