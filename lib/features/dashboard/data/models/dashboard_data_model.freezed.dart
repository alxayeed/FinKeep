// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardDataModel {

 double get totalIncome; double get totalExpense; double get netSavings; double get savingsRate; double get monthlyBudget; double get totalGivenDue; double get totalReceivedDue; double get totalInvested; double get totalInvestmentProfit; List<DashboardCategoryBreakdown> get expenseBreakdown; List<DashboardCategoryBreakdown> get incomeBreakdown; List<DashboardTrendPoint> get trends; List<DashboardRecentActivity> get recentActivities;
/// Create a copy of DashboardDataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDataModelCopyWith<DashboardDataModel> get copyWith => _$DashboardDataModelCopyWithImpl<DashboardDataModel>(this as DashboardDataModel, _$identity);

  /// Serializes this DashboardDataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardDataModel&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netSavings, netSavings) || other.netSavings == netSavings)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.totalGivenDue, totalGivenDue) || other.totalGivenDue == totalGivenDue)&&(identical(other.totalReceivedDue, totalReceivedDue) || other.totalReceivedDue == totalReceivedDue)&&(identical(other.totalInvested, totalInvested) || other.totalInvested == totalInvested)&&(identical(other.totalInvestmentProfit, totalInvestmentProfit) || other.totalInvestmentProfit == totalInvestmentProfit)&&const DeepCollectionEquality().equals(other.expenseBreakdown, expenseBreakdown)&&const DeepCollectionEquality().equals(other.incomeBreakdown, incomeBreakdown)&&const DeepCollectionEquality().equals(other.trends, trends)&&const DeepCollectionEquality().equals(other.recentActivities, recentActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netSavings,savingsRate,monthlyBudget,totalGivenDue,totalReceivedDue,totalInvested,totalInvestmentProfit,const DeepCollectionEquality().hash(expenseBreakdown),const DeepCollectionEquality().hash(incomeBreakdown),const DeepCollectionEquality().hash(trends),const DeepCollectionEquality().hash(recentActivities));

@override
String toString() {
  return 'DashboardDataModel(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, savingsRate: $savingsRate, monthlyBudget: $monthlyBudget, totalGivenDue: $totalGivenDue, totalReceivedDue: $totalReceivedDue, totalInvested: $totalInvested, totalInvestmentProfit: $totalInvestmentProfit, expenseBreakdown: $expenseBreakdown, incomeBreakdown: $incomeBreakdown, trends: $trends, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class $DashboardDataModelCopyWith<$Res>  {
  factory $DashboardDataModelCopyWith(DashboardDataModel value, $Res Function(DashboardDataModel) _then) = _$DashboardDataModelCopyWithImpl;
@useResult
$Res call({
 double totalIncome, double totalExpense, double netSavings, double savingsRate, double monthlyBudget, double totalGivenDue, double totalReceivedDue, double totalInvested, double totalInvestmentProfit, List<DashboardCategoryBreakdown> expenseBreakdown, List<DashboardCategoryBreakdown> incomeBreakdown, List<DashboardTrendPoint> trends, List<DashboardRecentActivity> recentActivities
});




}
/// @nodoc
class _$DashboardDataModelCopyWithImpl<$Res>
    implements $DashboardDataModelCopyWith<$Res> {
  _$DashboardDataModelCopyWithImpl(this._self, this._then);

  final DashboardDataModel _self;
  final $Res Function(DashboardDataModel) _then;

/// Create a copy of DashboardDataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? netSavings = null,Object? savingsRate = null,Object? monthlyBudget = null,Object? totalGivenDue = null,Object? totalReceivedDue = null,Object? totalInvested = null,Object? totalInvestmentProfit = null,Object? expenseBreakdown = null,Object? incomeBreakdown = null,Object? trends = null,Object? recentActivities = null,}) {
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
as double,expenseBreakdown: null == expenseBreakdown ? _self.expenseBreakdown : expenseBreakdown // ignore: cast_nullable_to_non_nullable
as List<DashboardCategoryBreakdown>,incomeBreakdown: null == incomeBreakdown ? _self.incomeBreakdown : incomeBreakdown // ignore: cast_nullable_to_non_nullable
as List<DashboardCategoryBreakdown>,trends: null == trends ? _self.trends : trends // ignore: cast_nullable_to_non_nullable
as List<DashboardTrendPoint>,recentActivities: null == recentActivities ? _self.recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<DashboardRecentActivity>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardDataModel].
extension DashboardDataModelPatterns on DashboardDataModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardDataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardDataModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardDataModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardDataModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardDataModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardDataModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalIncome,  double totalExpense,  double netSavings,  double savingsRate,  double monthlyBudget,  double totalGivenDue,  double totalReceivedDue,  double totalInvested,  double totalInvestmentProfit,  List<DashboardCategoryBreakdown> expenseBreakdown,  List<DashboardCategoryBreakdown> incomeBreakdown,  List<DashboardTrendPoint> trends,  List<DashboardRecentActivity> recentActivities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardDataModel() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.netSavings,_that.savingsRate,_that.monthlyBudget,_that.totalGivenDue,_that.totalReceivedDue,_that.totalInvested,_that.totalInvestmentProfit,_that.expenseBreakdown,_that.incomeBreakdown,_that.trends,_that.recentActivities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalIncome,  double totalExpense,  double netSavings,  double savingsRate,  double monthlyBudget,  double totalGivenDue,  double totalReceivedDue,  double totalInvested,  double totalInvestmentProfit,  List<DashboardCategoryBreakdown> expenseBreakdown,  List<DashboardCategoryBreakdown> incomeBreakdown,  List<DashboardTrendPoint> trends,  List<DashboardRecentActivity> recentActivities)  $default,) {final _that = this;
switch (_that) {
case _DashboardDataModel():
return $default(_that.totalIncome,_that.totalExpense,_that.netSavings,_that.savingsRate,_that.monthlyBudget,_that.totalGivenDue,_that.totalReceivedDue,_that.totalInvested,_that.totalInvestmentProfit,_that.expenseBreakdown,_that.incomeBreakdown,_that.trends,_that.recentActivities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalIncome,  double totalExpense,  double netSavings,  double savingsRate,  double monthlyBudget,  double totalGivenDue,  double totalReceivedDue,  double totalInvested,  double totalInvestmentProfit,  List<DashboardCategoryBreakdown> expenseBreakdown,  List<DashboardCategoryBreakdown> incomeBreakdown,  List<DashboardTrendPoint> trends,  List<DashboardRecentActivity> recentActivities)?  $default,) {final _that = this;
switch (_that) {
case _DashboardDataModel() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.netSavings,_that.savingsRate,_that.monthlyBudget,_that.totalGivenDue,_that.totalReceivedDue,_that.totalInvested,_that.totalInvestmentProfit,_that.expenseBreakdown,_that.incomeBreakdown,_that.trends,_that.recentActivities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardDataModel extends DashboardDataModel {
  const _DashboardDataModel({required this.totalIncome, required this.totalExpense, required this.netSavings, required this.savingsRate, required this.monthlyBudget, required this.totalGivenDue, required this.totalReceivedDue, required this.totalInvested, required this.totalInvestmentProfit, required final  List<DashboardCategoryBreakdown> expenseBreakdown, required final  List<DashboardCategoryBreakdown> incomeBreakdown, required final  List<DashboardTrendPoint> trends, required final  List<DashboardRecentActivity> recentActivities}): _expenseBreakdown = expenseBreakdown,_incomeBreakdown = incomeBreakdown,_trends = trends,_recentActivities = recentActivities,super._();
  factory _DashboardDataModel.fromJson(Map<String, dynamic> json) => _$DashboardDataModelFromJson(json);

@override final  double totalIncome;
@override final  double totalExpense;
@override final  double netSavings;
@override final  double savingsRate;
@override final  double monthlyBudget;
@override final  double totalGivenDue;
@override final  double totalReceivedDue;
@override final  double totalInvested;
@override final  double totalInvestmentProfit;
 final  List<DashboardCategoryBreakdown> _expenseBreakdown;
@override List<DashboardCategoryBreakdown> get expenseBreakdown {
  if (_expenseBreakdown is EqualUnmodifiableListView) return _expenseBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenseBreakdown);
}

 final  List<DashboardCategoryBreakdown> _incomeBreakdown;
@override List<DashboardCategoryBreakdown> get incomeBreakdown {
  if (_incomeBreakdown is EqualUnmodifiableListView) return _incomeBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomeBreakdown);
}

 final  List<DashboardTrendPoint> _trends;
@override List<DashboardTrendPoint> get trends {
  if (_trends is EqualUnmodifiableListView) return _trends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trends);
}

 final  List<DashboardRecentActivity> _recentActivities;
@override List<DashboardRecentActivity> get recentActivities {
  if (_recentActivities is EqualUnmodifiableListView) return _recentActivities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivities);
}


/// Create a copy of DashboardDataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDataModelCopyWith<_DashboardDataModel> get copyWith => __$DashboardDataModelCopyWithImpl<_DashboardDataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardDataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardDataModel&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netSavings, netSavings) || other.netSavings == netSavings)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.totalGivenDue, totalGivenDue) || other.totalGivenDue == totalGivenDue)&&(identical(other.totalReceivedDue, totalReceivedDue) || other.totalReceivedDue == totalReceivedDue)&&(identical(other.totalInvested, totalInvested) || other.totalInvested == totalInvested)&&(identical(other.totalInvestmentProfit, totalInvestmentProfit) || other.totalInvestmentProfit == totalInvestmentProfit)&&const DeepCollectionEquality().equals(other._expenseBreakdown, _expenseBreakdown)&&const DeepCollectionEquality().equals(other._incomeBreakdown, _incomeBreakdown)&&const DeepCollectionEquality().equals(other._trends, _trends)&&const DeepCollectionEquality().equals(other._recentActivities, _recentActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netSavings,savingsRate,monthlyBudget,totalGivenDue,totalReceivedDue,totalInvested,totalInvestmentProfit,const DeepCollectionEquality().hash(_expenseBreakdown),const DeepCollectionEquality().hash(_incomeBreakdown),const DeepCollectionEquality().hash(_trends),const DeepCollectionEquality().hash(_recentActivities));

@override
String toString() {
  return 'DashboardDataModel(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, savingsRate: $savingsRate, monthlyBudget: $monthlyBudget, totalGivenDue: $totalGivenDue, totalReceivedDue: $totalReceivedDue, totalInvested: $totalInvested, totalInvestmentProfit: $totalInvestmentProfit, expenseBreakdown: $expenseBreakdown, incomeBreakdown: $incomeBreakdown, trends: $trends, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class _$DashboardDataModelCopyWith<$Res> implements $DashboardDataModelCopyWith<$Res> {
  factory _$DashboardDataModelCopyWith(_DashboardDataModel value, $Res Function(_DashboardDataModel) _then) = __$DashboardDataModelCopyWithImpl;
@override @useResult
$Res call({
 double totalIncome, double totalExpense, double netSavings, double savingsRate, double monthlyBudget, double totalGivenDue, double totalReceivedDue, double totalInvested, double totalInvestmentProfit, List<DashboardCategoryBreakdown> expenseBreakdown, List<DashboardCategoryBreakdown> incomeBreakdown, List<DashboardTrendPoint> trends, List<DashboardRecentActivity> recentActivities
});




}
/// @nodoc
class __$DashboardDataModelCopyWithImpl<$Res>
    implements _$DashboardDataModelCopyWith<$Res> {
  __$DashboardDataModelCopyWithImpl(this._self, this._then);

  final _DashboardDataModel _self;
  final $Res Function(_DashboardDataModel) _then;

/// Create a copy of DashboardDataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? netSavings = null,Object? savingsRate = null,Object? monthlyBudget = null,Object? totalGivenDue = null,Object? totalReceivedDue = null,Object? totalInvested = null,Object? totalInvestmentProfit = null,Object? expenseBreakdown = null,Object? incomeBreakdown = null,Object? trends = null,Object? recentActivities = null,}) {
  return _then(_DashboardDataModel(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,netSavings: null == netSavings ? _self.netSavings : netSavings // ignore: cast_nullable_to_non_nullable
as double,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as double,monthlyBudget: null == monthlyBudget ? _self.monthlyBudget : monthlyBudget // ignore: cast_nullable_to_non_nullable
as double,totalGivenDue: null == totalGivenDue ? _self.totalGivenDue : totalGivenDue // ignore: cast_nullable_to_non_nullable
as double,totalReceivedDue: null == totalReceivedDue ? _self.totalReceivedDue : totalReceivedDue // ignore: cast_nullable_to_non_nullable
as double,totalInvested: null == totalInvested ? _self.totalInvested : totalInvested // ignore: cast_nullable_to_non_nullable
as double,totalInvestmentProfit: null == totalInvestmentProfit ? _self.totalInvestmentProfit : totalInvestmentProfit // ignore: cast_nullable_to_non_nullable
as double,expenseBreakdown: null == expenseBreakdown ? _self._expenseBreakdown : expenseBreakdown // ignore: cast_nullable_to_non_nullable
as List<DashboardCategoryBreakdown>,incomeBreakdown: null == incomeBreakdown ? _self._incomeBreakdown : incomeBreakdown // ignore: cast_nullable_to_non_nullable
as List<DashboardCategoryBreakdown>,trends: null == trends ? _self._trends : trends // ignore: cast_nullable_to_non_nullable
as List<DashboardTrendPoint>,recentActivities: null == recentActivities ? _self._recentActivities : recentActivities // ignore: cast_nullable_to_non_nullable
as List<DashboardRecentActivity>,
  ));
}


}

// dart format on
