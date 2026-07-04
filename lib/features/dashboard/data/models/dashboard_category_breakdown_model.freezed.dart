// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_category_breakdown_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardCategoryBreakdownModel {

 String get categoryName; double get amount; double get percentage; String? get emoji;
/// Create a copy of DashboardCategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCategoryBreakdownModelCopyWith<DashboardCategoryBreakdownModel> get copyWith => _$DashboardCategoryBreakdownModelCopyWithImpl<DashboardCategoryBreakdownModel>(this as DashboardCategoryBreakdownModel, _$identity);

  /// Serializes this DashboardCategoryBreakdownModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardCategoryBreakdownModel&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,amount,percentage,emoji);

@override
String toString() {
  return 'DashboardCategoryBreakdownModel(categoryName: $categoryName, amount: $amount, percentage: $percentage, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $DashboardCategoryBreakdownModelCopyWith<$Res>  {
  factory $DashboardCategoryBreakdownModelCopyWith(DashboardCategoryBreakdownModel value, $Res Function(DashboardCategoryBreakdownModel) _then) = _$DashboardCategoryBreakdownModelCopyWithImpl;
@useResult
$Res call({
 String categoryName, double amount, double percentage, String? emoji
});




}
/// @nodoc
class _$DashboardCategoryBreakdownModelCopyWithImpl<$Res>
    implements $DashboardCategoryBreakdownModelCopyWith<$Res> {
  _$DashboardCategoryBreakdownModelCopyWithImpl(this._self, this._then);

  final DashboardCategoryBreakdownModel _self;
  final $Res Function(DashboardCategoryBreakdownModel) _then;

/// Create a copy of DashboardCategoryBreakdownModel
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


/// Adds pattern-matching-related methods to [DashboardCategoryBreakdownModel].
extension DashboardCategoryBreakdownModelPatterns on DashboardCategoryBreakdownModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardCategoryBreakdownModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardCategoryBreakdownModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardCategoryBreakdownModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownModel() when $default != null:
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
case _DashboardCategoryBreakdownModel() when $default != null:
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
case _DashboardCategoryBreakdownModel():
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
case _DashboardCategoryBreakdownModel() when $default != null:
return $default(_that.categoryName,_that.amount,_that.percentage,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardCategoryBreakdownModel extends DashboardCategoryBreakdownModel {
  const _DashboardCategoryBreakdownModel({required this.categoryName, required this.amount, required this.percentage, this.emoji}): super._();
  factory _DashboardCategoryBreakdownModel.fromJson(Map<String, dynamic> json) => _$DashboardCategoryBreakdownModelFromJson(json);

@override final  String categoryName;
@override final  double amount;
@override final  double percentage;
@override final  String? emoji;

/// Create a copy of DashboardCategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCategoryBreakdownModelCopyWith<_DashboardCategoryBreakdownModel> get copyWith => __$DashboardCategoryBreakdownModelCopyWithImpl<_DashboardCategoryBreakdownModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardCategoryBreakdownModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardCategoryBreakdownModel&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,amount,percentage,emoji);

@override
String toString() {
  return 'DashboardCategoryBreakdownModel(categoryName: $categoryName, amount: $amount, percentage: $percentage, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$DashboardCategoryBreakdownModelCopyWith<$Res> implements $DashboardCategoryBreakdownModelCopyWith<$Res> {
  factory _$DashboardCategoryBreakdownModelCopyWith(_DashboardCategoryBreakdownModel value, $Res Function(_DashboardCategoryBreakdownModel) _then) = __$DashboardCategoryBreakdownModelCopyWithImpl;
@override @useResult
$Res call({
 String categoryName, double amount, double percentage, String? emoji
});




}
/// @nodoc
class __$DashboardCategoryBreakdownModelCopyWithImpl<$Res>
    implements _$DashboardCategoryBreakdownModelCopyWith<$Res> {
  __$DashboardCategoryBreakdownModelCopyWithImpl(this._self, this._then);

  final _DashboardCategoryBreakdownModel _self;
  final $Res Function(_DashboardCategoryBreakdownModel) _then;

/// Create a copy of DashboardCategoryBreakdownModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryName = null,Object? amount = null,Object? percentage = null,Object? emoji = freezed,}) {
  return _then(_DashboardCategoryBreakdownModel(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
