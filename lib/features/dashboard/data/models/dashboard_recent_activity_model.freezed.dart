// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_recent_activity_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardRecentActivityModel {

 String get id; String get title; String get category; double get amount; DateTime get date; String get type; String? get emoji;
/// Create a copy of DashboardRecentActivityModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardRecentActivityModelCopyWith<DashboardRecentActivityModel> get copyWith => _$DashboardRecentActivityModelCopyWithImpl<DashboardRecentActivityModel>(this as DashboardRecentActivityModel, _$identity);

  /// Serializes this DashboardRecentActivityModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardRecentActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,amount,date,type,emoji);

@override
String toString() {
  return 'DashboardRecentActivityModel(id: $id, title: $title, category: $category, amount: $amount, date: $date, type: $type, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $DashboardRecentActivityModelCopyWith<$Res>  {
  factory $DashboardRecentActivityModelCopyWith(DashboardRecentActivityModel value, $Res Function(DashboardRecentActivityModel) _then) = _$DashboardRecentActivityModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String category, double amount, DateTime date, String type, String? emoji
});




}
/// @nodoc
class _$DashboardRecentActivityModelCopyWithImpl<$Res>
    implements $DashboardRecentActivityModelCopyWith<$Res> {
  _$DashboardRecentActivityModelCopyWithImpl(this._self, this._then);

  final DashboardRecentActivityModel _self;
  final $Res Function(DashboardRecentActivityModel) _then;

/// Create a copy of DashboardRecentActivityModel
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


/// Adds pattern-matching-related methods to [DashboardRecentActivityModel].
extension DashboardRecentActivityModelPatterns on DashboardRecentActivityModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardRecentActivityModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardRecentActivityModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardRecentActivityModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardRecentActivityModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardRecentActivityModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardRecentActivityModel() when $default != null:
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
case _DashboardRecentActivityModel() when $default != null:
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
case _DashboardRecentActivityModel():
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
case _DashboardRecentActivityModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.amount,_that.date,_that.type,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardRecentActivityModel extends DashboardRecentActivityModel {
  const _DashboardRecentActivityModel({required this.id, required this.title, required this.category, required this.amount, required this.date, required this.type, this.emoji}): super._();
  factory _DashboardRecentActivityModel.fromJson(Map<String, dynamic> json) => _$DashboardRecentActivityModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String category;
@override final  double amount;
@override final  DateTime date;
@override final  String type;
@override final  String? emoji;

/// Create a copy of DashboardRecentActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardRecentActivityModelCopyWith<_DashboardRecentActivityModel> get copyWith => __$DashboardRecentActivityModelCopyWithImpl<_DashboardRecentActivityModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardRecentActivityModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardRecentActivityModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.type, type) || other.type == type)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,amount,date,type,emoji);

@override
String toString() {
  return 'DashboardRecentActivityModel(id: $id, title: $title, category: $category, amount: $amount, date: $date, type: $type, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$DashboardRecentActivityModelCopyWith<$Res> implements $DashboardRecentActivityModelCopyWith<$Res> {
  factory _$DashboardRecentActivityModelCopyWith(_DashboardRecentActivityModel value, $Res Function(_DashboardRecentActivityModel) _then) = __$DashboardRecentActivityModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String category, double amount, DateTime date, String type, String? emoji
});




}
/// @nodoc
class __$DashboardRecentActivityModelCopyWithImpl<$Res>
    implements _$DashboardRecentActivityModelCopyWith<$Res> {
  __$DashboardRecentActivityModelCopyWithImpl(this._self, this._then);

  final _DashboardRecentActivityModel _self;
  final $Res Function(_DashboardRecentActivityModel) _then;

/// Create a copy of DashboardRecentActivityModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? amount = null,Object? date = null,Object? type = null,Object? emoji = freezed,}) {
  return _then(_DashboardRecentActivityModel(
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

// dart format on
