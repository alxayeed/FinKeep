// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardCategoryBreakdown {

 String get categoryName; double get amount; double get percentage; String? get emoji;
/// Create a copy of DashboardCategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCategoryBreakdownCopyWith<DashboardCategoryBreakdown> get copyWith => _$DashboardCategoryBreakdownCopyWithImpl<DashboardCategoryBreakdown>(this as DashboardCategoryBreakdown, _$identity);

  /// Serializes this DashboardCategoryBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardCategoryBreakdown&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,amount,percentage,emoji);

@override
String toString() {
  return 'DashboardCategoryBreakdown(categoryName: $categoryName, amount: $amount, percentage: $percentage, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $DashboardCategoryBreakdownCopyWith<$Res>  {
  factory $DashboardCategoryBreakdownCopyWith(DashboardCategoryBreakdown value, $Res Function(DashboardCategoryBreakdown) _then) = _$DashboardCategoryBreakdownCopyWithImpl;
@useResult
$Res call({
 String categoryName, double amount, double percentage, String? emoji
});




}
/// @nodoc
class _$DashboardCategoryBreakdownCopyWithImpl<$Res>
    implements $DashboardCategoryBreakdownCopyWith<$Res> {
  _$DashboardCategoryBreakdownCopyWithImpl(this._self, this._then);

  final DashboardCategoryBreakdown _self;
  final $Res Function(DashboardCategoryBreakdown) _then;

/// Create a copy of DashboardCategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryName = null,Object? amount = null,Object? percentage = null,Object? emoji = freezed,}) {
  return _then(_self.copyWith(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardCategoryBreakdown].
extension DashboardCategoryBreakdownPatterns on DashboardCategoryBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardCategoryBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardCategoryBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardCategoryBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryName,  double amount,  double percentage,  String? emoji)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardCategoryBreakdown() when $default != null:
return $default(_that.categoryName,_that.amount,_that.percentage,_that.emoji);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryName,  double amount,  double percentage,  String? emoji)  $default,) {final _that = this;
switch (_that) {
case _DashboardCategoryBreakdown():
return $default(_that.categoryName,_that.amount,_that.percentage,_that.emoji);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryName,  double amount,  double percentage,  String? emoji)?  $default,) {final _that = this;
switch (_that) {
case _DashboardCategoryBreakdown() when $default != null:
return $default(_that.categoryName,_that.amount,_that.percentage,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardCategoryBreakdown implements DashboardCategoryBreakdown {
  const _DashboardCategoryBreakdown({required this.categoryName, required this.amount, required this.percentage, this.emoji});
  factory _DashboardCategoryBreakdown.fromJson(Map<String, dynamic> json) => _$DashboardCategoryBreakdownFromJson(json);

@override final  String categoryName;
@override final  double amount;
@override final  double percentage;
@override final  String? emoji;

/// Create a copy of DashboardCategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCategoryBreakdownCopyWith<_DashboardCategoryBreakdown> get copyWith => __$DashboardCategoryBreakdownCopyWithImpl<_DashboardCategoryBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardCategoryBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardCategoryBreakdown&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,amount,percentage,emoji);

@override
String toString() {
  return 'DashboardCategoryBreakdown(categoryName: $categoryName, amount: $amount, percentage: $percentage, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$DashboardCategoryBreakdownCopyWith<$Res> implements $DashboardCategoryBreakdownCopyWith<$Res> {
  factory _$DashboardCategoryBreakdownCopyWith(_DashboardCategoryBreakdown value, $Res Function(_DashboardCategoryBreakdown) _then) = __$DashboardCategoryBreakdownCopyWithImpl;
@override @useResult
$Res call({
 String categoryName, double amount, double percentage, String? emoji
});




}
/// @nodoc
class __$DashboardCategoryBreakdownCopyWithImpl<$Res>
    implements _$DashboardCategoryBreakdownCopyWith<$Res> {
  __$DashboardCategoryBreakdownCopyWithImpl(this._self, this._then);

  final _DashboardCategoryBreakdown _self;
  final $Res Function(_DashboardCategoryBreakdown) _then;

/// Create a copy of DashboardCategoryBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryName = null,Object? amount = null,Object? percentage = null,Object? emoji = freezed,}) {
  return _then(_DashboardCategoryBreakdown(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DashboardTrendPoint {

 DateTime get date; double get income; double get expense; double get balance;
/// Create a copy of DashboardTrendPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardTrendPointCopyWith<DashboardTrendPoint> get copyWith => _$DashboardTrendPointCopyWithImpl<DashboardTrendPoint>(this as DashboardTrendPoint, _$identity);

  /// Serializes this DashboardTrendPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardTrendPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,expense,balance);

@override
String toString() {
  return 'DashboardTrendPoint(date: $date, income: $income, expense: $expense, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $DashboardTrendPointCopyWith<$Res>  {
  factory $DashboardTrendPointCopyWith(DashboardTrendPoint value, $Res Function(DashboardTrendPoint) _then) = _$DashboardTrendPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double income, double expense, double balance
});




}
/// @nodoc
class _$DashboardTrendPointCopyWithImpl<$Res>
    implements $DashboardTrendPointCopyWith<$Res> {
  _$DashboardTrendPointCopyWithImpl(this._self, this._then);

  final DashboardTrendPoint _self;
  final $Res Function(DashboardTrendPoint) _then;

/// Create a copy of DashboardTrendPoint
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


/// Adds pattern-matching-related methods to [DashboardTrendPoint].
extension DashboardTrendPointPatterns on DashboardTrendPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardTrendPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardTrendPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardTrendPoint value)  $default,){
final _that = this;
switch (_that) {
case _DashboardTrendPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardTrendPoint value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardTrendPoint() when $default != null:
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
case _DashboardTrendPoint() when $default != null:
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
case _DashboardTrendPoint():
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
case _DashboardTrendPoint() when $default != null:
return $default(_that.date,_that.income,_that.expense,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardTrendPoint implements DashboardTrendPoint {
  const _DashboardTrendPoint({required this.date, required this.income, required this.expense, required this.balance});
  factory _DashboardTrendPoint.fromJson(Map<String, dynamic> json) => _$DashboardTrendPointFromJson(json);

@override final  DateTime date;
@override final  double income;
@override final  double expense;
@override final  double balance;

/// Create a copy of DashboardTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardTrendPointCopyWith<_DashboardTrendPoint> get copyWith => __$DashboardTrendPointCopyWithImpl<_DashboardTrendPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardTrendPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardTrendPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.expense, expense) || other.expense == expense)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,expense,balance);

@override
String toString() {
  return 'DashboardTrendPoint(date: $date, income: $income, expense: $expense, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$DashboardTrendPointCopyWith<$Res> implements $DashboardTrendPointCopyWith<$Res> {
  factory _$DashboardTrendPointCopyWith(_DashboardTrendPoint value, $Res Function(_DashboardTrendPoint) _then) = __$DashboardTrendPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double income, double expense, double balance
});




}
/// @nodoc
class __$DashboardTrendPointCopyWithImpl<$Res>
    implements _$DashboardTrendPointCopyWith<$Res> {
  __$DashboardTrendPointCopyWithImpl(this._self, this._then);

  final _DashboardTrendPoint _self;
  final $Res Function(_DashboardTrendPoint) _then;

/// Create a copy of DashboardTrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? income = null,Object? expense = null,Object? balance = null,}) {
  return _then(_DashboardTrendPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expense: null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as double,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DashboardRecentActivity {

 String get id; String get title; String get category; double get amount; DateTime get date; String get type;// 'income', 'expense', 'lending', 'investment'
 String? get emoji;
/// Create a copy of DashboardRecentActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardRecentActivityCopyWith<DashboardRecentActivity> get copyWith => _$DashboardRecentActivityCopyWithImpl<DashboardRecentActivity>(this as DashboardRecentActivity, _$identity);

  /// Serializes this DashboardRecentActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardRecentActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,amount,date,type,emoji);

@override
String toString() {
  return 'DashboardRecentActivity(id: $id, title: $title, category: $category, amount: $amount, date: $date, type: $type, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $DashboardRecentActivityCopyWith<$Res>  {
  factory $DashboardRecentActivityCopyWith(DashboardRecentActivity value, $Res Function(DashboardRecentActivity) _then) = _$DashboardRecentActivityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String category, double amount, DateTime date, String type, String? emoji
});




}
/// @nodoc
class _$DashboardRecentActivityCopyWithImpl<$Res>
    implements $DashboardRecentActivityCopyWith<$Res> {
  _$DashboardRecentActivityCopyWithImpl(this._self, this._then);

  final DashboardRecentActivity _self;
  final $Res Function(DashboardRecentActivity) _then;

/// Create a copy of DashboardRecentActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? amount = null,Object? date = null,Object? type = null,Object? emoji = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardRecentActivity].
extension DashboardRecentActivityPatterns on DashboardRecentActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardRecentActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardRecentActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardRecentActivity value)  $default,){
final _that = this;
switch (_that) {
case _DashboardRecentActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardRecentActivity value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardRecentActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double amount,  DateTime date,  String type,  String? emoji)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardRecentActivity() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.amount,_that.date,_that.type,_that.emoji);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String category,  double amount,  DateTime date,  String type,  String? emoji)  $default,) {final _that = this;
switch (_that) {
case _DashboardRecentActivity():
return $default(_that.id,_that.title,_that.category,_that.amount,_that.date,_that.type,_that.emoji);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String category,  double amount,  DateTime date,  String type,  String? emoji)?  $default,) {final _that = this;
switch (_that) {
case _DashboardRecentActivity() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.amount,_that.date,_that.type,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardRecentActivity implements DashboardRecentActivity {
  const _DashboardRecentActivity({required this.id, required this.title, required this.category, required this.amount, required this.date, required this.type, this.emoji});
  factory _DashboardRecentActivity.fromJson(Map<String, dynamic> json) => _$DashboardRecentActivityFromJson(json);

@override final  String id;
@override final  String title;
@override final  String category;
@override final  double amount;
@override final  DateTime date;
@override final  String type;
// 'income', 'expense', 'lending', 'investment'
@override final  String? emoji;

/// Create a copy of DashboardRecentActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardRecentActivityCopyWith<_DashboardRecentActivity> get copyWith => __$DashboardRecentActivityCopyWithImpl<_DashboardRecentActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardRecentActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardRecentActivity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,amount,date,type,emoji);

@override
String toString() {
  return 'DashboardRecentActivity(id: $id, title: $title, category: $category, amount: $amount, date: $date, type: $type, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$DashboardRecentActivityCopyWith<$Res> implements $DashboardRecentActivityCopyWith<$Res> {
  factory _$DashboardRecentActivityCopyWith(_DashboardRecentActivity value, $Res Function(_DashboardRecentActivity) _then) = __$DashboardRecentActivityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String category, double amount, DateTime date, String type, String? emoji
});




}
/// @nodoc
class __$DashboardRecentActivityCopyWithImpl<$Res>
    implements _$DashboardRecentActivityCopyWith<$Res> {
  __$DashboardRecentActivityCopyWithImpl(this._self, this._then);

  final _DashboardRecentActivity _self;
  final $Res Function(_DashboardRecentActivity) _then;

/// Create a copy of DashboardRecentActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? amount = null,Object? date = null,Object? type = null,Object? emoji = freezed,}) {
  return _then(_DashboardRecentActivity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DashboardDataEntity {

 double get totalIncome; double get totalExpense; double get netSavings; double get savingsRate; double get monthlyBudget; double get totalGivenDue; double get totalReceivedDue; double get totalInvested; double get totalInvestmentProfit; List<DashboardCategoryBreakdown> get expenseBreakdown; List<DashboardCategoryBreakdown> get incomeBreakdown; List<DashboardTrendPoint> get trends; List<DashboardRecentActivity> get recentActivities;
/// Create a copy of DashboardDataEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDataEntityCopyWith<DashboardDataEntity> get copyWith => _$DashboardDataEntityCopyWithImpl<DashboardDataEntity>(this as DashboardDataEntity, _$identity);

  /// Serializes this DashboardDataEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardDataEntity&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netSavings, netSavings) || other.netSavings == netSavings)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.totalGivenDue, totalGivenDue) || other.totalGivenDue == totalGivenDue)&&(identical(other.totalReceivedDue, totalReceivedDue) || other.totalReceivedDue == totalReceivedDue)&&(identical(other.totalInvested, totalInvested) || other.totalInvested == totalInvested)&&(identical(other.totalInvestmentProfit, totalInvestmentProfit) || other.totalInvestmentProfit == totalInvestmentProfit)&&const DeepCollectionEquality().equals(other.expenseBreakdown, expenseBreakdown)&&const DeepCollectionEquality().equals(other.incomeBreakdown, incomeBreakdown)&&const DeepCollectionEquality().equals(other.trends, trends)&&const DeepCollectionEquality().equals(other.recentActivities, recentActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netSavings,savingsRate,monthlyBudget,totalGivenDue,totalReceivedDue,totalInvested,totalInvestmentProfit,const DeepCollectionEquality().hash(expenseBreakdown),const DeepCollectionEquality().hash(incomeBreakdown),const DeepCollectionEquality().hash(trends),const DeepCollectionEquality().hash(recentActivities));

@override
String toString() {
  return 'DashboardDataEntity(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, savingsRate: $savingsRate, monthlyBudget: $monthlyBudget, totalGivenDue: $totalGivenDue, totalReceivedDue: $totalReceivedDue, totalInvested: $totalInvested, totalInvestmentProfit: $totalInvestmentProfit, expenseBreakdown: $expenseBreakdown, incomeBreakdown: $incomeBreakdown, trends: $trends, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class $DashboardDataEntityCopyWith<$Res>  {
  factory $DashboardDataEntityCopyWith(DashboardDataEntity value, $Res Function(DashboardDataEntity) _then) = _$DashboardDataEntityCopyWithImpl;
@useResult
$Res call({
 double totalIncome, double totalExpense, double netSavings, double savingsRate, double monthlyBudget, double totalGivenDue, double totalReceivedDue, double totalInvested, double totalInvestmentProfit, List<DashboardCategoryBreakdown> expenseBreakdown, List<DashboardCategoryBreakdown> incomeBreakdown, List<DashboardTrendPoint> trends, List<DashboardRecentActivity> recentActivities
});




}
/// @nodoc
class _$DashboardDataEntityCopyWithImpl<$Res>
    implements $DashboardDataEntityCopyWith<$Res> {
  _$DashboardDataEntityCopyWithImpl(this._self, this._then);

  final DashboardDataEntity _self;
  final $Res Function(DashboardDataEntity) _then;

/// Create a copy of DashboardDataEntity
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


/// Adds pattern-matching-related methods to [DashboardDataEntity].
extension DashboardDataEntityPatterns on DashboardDataEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardDataEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardDataEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardDataEntity value)  $default,){
final _that = this;
switch (_that) {
case _DashboardDataEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardDataEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardDataEntity() when $default != null:
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
case _DashboardDataEntity() when $default != null:
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
case _DashboardDataEntity():
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
case _DashboardDataEntity() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.netSavings,_that.savingsRate,_that.monthlyBudget,_that.totalGivenDue,_that.totalReceivedDue,_that.totalInvested,_that.totalInvestmentProfit,_that.expenseBreakdown,_that.incomeBreakdown,_that.trends,_that.recentActivities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardDataEntity implements DashboardDataEntity {
  const _DashboardDataEntity({required this.totalIncome, required this.totalExpense, required this.netSavings, required this.savingsRate, required this.monthlyBudget, required this.totalGivenDue, required this.totalReceivedDue, required this.totalInvested, required this.totalInvestmentProfit, required final  List<DashboardCategoryBreakdown> expenseBreakdown, required final  List<DashboardCategoryBreakdown> incomeBreakdown, required final  List<DashboardTrendPoint> trends, required final  List<DashboardRecentActivity> recentActivities}): _expenseBreakdown = expenseBreakdown,_incomeBreakdown = incomeBreakdown,_trends = trends,_recentActivities = recentActivities;
  factory _DashboardDataEntity.fromJson(Map<String, dynamic> json) => _$DashboardDataEntityFromJson(json);

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


/// Create a copy of DashboardDataEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDataEntityCopyWith<_DashboardDataEntity> get copyWith => __$DashboardDataEntityCopyWithImpl<_DashboardDataEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardDataEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardDataEntity&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netSavings, netSavings) || other.netSavings == netSavings)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.monthlyBudget, monthlyBudget) || other.monthlyBudget == monthlyBudget)&&(identical(other.totalGivenDue, totalGivenDue) || other.totalGivenDue == totalGivenDue)&&(identical(other.totalReceivedDue, totalReceivedDue) || other.totalReceivedDue == totalReceivedDue)&&(identical(other.totalInvested, totalInvested) || other.totalInvested == totalInvested)&&(identical(other.totalInvestmentProfit, totalInvestmentProfit) || other.totalInvestmentProfit == totalInvestmentProfit)&&const DeepCollectionEquality().equals(other._expenseBreakdown, _expenseBreakdown)&&const DeepCollectionEquality().equals(other._incomeBreakdown, _incomeBreakdown)&&const DeepCollectionEquality().equals(other._trends, _trends)&&const DeepCollectionEquality().equals(other._recentActivities, _recentActivities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netSavings,savingsRate,monthlyBudget,totalGivenDue,totalReceivedDue,totalInvested,totalInvestmentProfit,const DeepCollectionEquality().hash(_expenseBreakdown),const DeepCollectionEquality().hash(_incomeBreakdown),const DeepCollectionEquality().hash(_trends),const DeepCollectionEquality().hash(_recentActivities));

@override
String toString() {
  return 'DashboardDataEntity(totalIncome: $totalIncome, totalExpense: $totalExpense, netSavings: $netSavings, savingsRate: $savingsRate, monthlyBudget: $monthlyBudget, totalGivenDue: $totalGivenDue, totalReceivedDue: $totalReceivedDue, totalInvested: $totalInvested, totalInvestmentProfit: $totalInvestmentProfit, expenseBreakdown: $expenseBreakdown, incomeBreakdown: $incomeBreakdown, trends: $trends, recentActivities: $recentActivities)';
}


}

/// @nodoc
abstract mixin class _$DashboardDataEntityCopyWith<$Res> implements $DashboardDataEntityCopyWith<$Res> {
  factory _$DashboardDataEntityCopyWith(_DashboardDataEntity value, $Res Function(_DashboardDataEntity) _then) = __$DashboardDataEntityCopyWithImpl;
@override @useResult
$Res call({
 double totalIncome, double totalExpense, double netSavings, double savingsRate, double monthlyBudget, double totalGivenDue, double totalReceivedDue, double totalInvested, double totalInvestmentProfit, List<DashboardCategoryBreakdown> expenseBreakdown, List<DashboardCategoryBreakdown> incomeBreakdown, List<DashboardTrendPoint> trends, List<DashboardRecentActivity> recentActivities
});




}
/// @nodoc
class __$DashboardDataEntityCopyWithImpl<$Res>
    implements _$DashboardDataEntityCopyWith<$Res> {
  __$DashboardDataEntityCopyWithImpl(this._self, this._then);

  final _DashboardDataEntity _self;
  final $Res Function(_DashboardDataEntity) _then;

/// Create a copy of DashboardDataEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? netSavings = null,Object? savingsRate = null,Object? monthlyBudget = null,Object? totalGivenDue = null,Object? totalReceivedDue = null,Object? totalInvested = null,Object? totalInvestmentProfit = null,Object? expenseBreakdown = null,Object? incomeBreakdown = null,Object? trends = null,Object? recentActivities = null,}) {
  return _then(_DashboardDataEntity(
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
