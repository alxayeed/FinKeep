// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_category_breakdown_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardCategoryBreakdownEntity {

 String get categoryName; double get amount; double get percentage; String? get emoji;
/// Create a copy of DashboardCategoryBreakdownEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCategoryBreakdownEntityCopyWith<DashboardCategoryBreakdownEntity> get copyWith => _$DashboardCategoryBreakdownEntityCopyWithImpl<DashboardCategoryBreakdownEntity>(this as DashboardCategoryBreakdownEntity, _$identity);

  /// Serializes this DashboardCategoryBreakdownEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardCategoryBreakdownEntity&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,amount,percentage,emoji);

@override
String toString() {
  return 'DashboardCategoryBreakdownEntity(categoryName: $categoryName, amount: $amount, percentage: $percentage, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $DashboardCategoryBreakdownEntityCopyWith<$Res>  {
  factory $DashboardCategoryBreakdownEntityCopyWith(DashboardCategoryBreakdownEntity value, $Res Function(DashboardCategoryBreakdownEntity) _then) = _$DashboardCategoryBreakdownEntityCopyWithImpl;
@useResult
$Res call({
 String categoryName, double amount, double percentage, String? emoji
});




}
/// @nodoc
class _$DashboardCategoryBreakdownEntityCopyWithImpl<$Res>
    implements $DashboardCategoryBreakdownEntityCopyWith<$Res> {
  _$DashboardCategoryBreakdownEntityCopyWithImpl(this._self, this._then);

  final DashboardCategoryBreakdownEntity _self;
  final $Res Function(DashboardCategoryBreakdownEntity) _then;

/// Create a copy of DashboardCategoryBreakdownEntity
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


/// Adds pattern-matching-related methods to [DashboardCategoryBreakdownEntity].
extension DashboardCategoryBreakdownEntityPatterns on DashboardCategoryBreakdownEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardCategoryBreakdownEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardCategoryBreakdownEntity value)  $default,){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardCategoryBreakdownEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardCategoryBreakdownEntity() when $default != null:
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
case _DashboardCategoryBreakdownEntity() when $default != null:
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
case _DashboardCategoryBreakdownEntity():
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
case _DashboardCategoryBreakdownEntity() when $default != null:
return $default(_that.categoryName,_that.amount,_that.percentage,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardCategoryBreakdownEntity implements DashboardCategoryBreakdownEntity {
  const _DashboardCategoryBreakdownEntity({required this.categoryName, required this.amount, required this.percentage, this.emoji});
  factory _DashboardCategoryBreakdownEntity.fromJson(Map<String, dynamic> json) => _$DashboardCategoryBreakdownEntityFromJson(json);

@override final  String categoryName;
@override final  double amount;
@override final  double percentage;
@override final  String? emoji;

/// Create a copy of DashboardCategoryBreakdownEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCategoryBreakdownEntityCopyWith<_DashboardCategoryBreakdownEntity> get copyWith => __$DashboardCategoryBreakdownEntityCopyWithImpl<_DashboardCategoryBreakdownEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardCategoryBreakdownEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardCategoryBreakdownEntity&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryName,amount,percentage,emoji);

@override
String toString() {
  return 'DashboardCategoryBreakdownEntity(categoryName: $categoryName, amount: $amount, percentage: $percentage, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$DashboardCategoryBreakdownEntityCopyWith<$Res> implements $DashboardCategoryBreakdownEntityCopyWith<$Res> {
  factory _$DashboardCategoryBreakdownEntityCopyWith(_DashboardCategoryBreakdownEntity value, $Res Function(_DashboardCategoryBreakdownEntity) _then) = __$DashboardCategoryBreakdownEntityCopyWithImpl;
@override @useResult
$Res call({
 String categoryName, double amount, double percentage, String? emoji
});




}
/// @nodoc
class __$DashboardCategoryBreakdownEntityCopyWithImpl<$Res>
    implements _$DashboardCategoryBreakdownEntityCopyWith<$Res> {
  __$DashboardCategoryBreakdownEntityCopyWithImpl(this._self, this._then);

  final _DashboardCategoryBreakdownEntity _self;
  final $Res Function(_DashboardCategoryBreakdownEntity) _then;

/// Create a copy of DashboardCategoryBreakdownEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryName = null,Object? amount = null,Object? percentage = null,Object? emoji = freezed,}) {
  return _then(_DashboardCategoryBreakdownEntity(
categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
