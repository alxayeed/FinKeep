// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income_category_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IncomeCategoryEntity {

 String get id; String get displayLabel; String get emoji; bool get isCustom; bool get isDeleted;
/// Create a copy of IncomeCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeCategoryEntityCopyWith<IncomeCategoryEntity> get copyWith => _$IncomeCategoryEntityCopyWithImpl<IncomeCategoryEntity>(this as IncomeCategoryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomeCategoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayLabel,emoji,isCustom,isDeleted);

@override
String toString() {
  return 'IncomeCategoryEntity(id: $id, displayLabel: $displayLabel, emoji: $emoji, isCustom: $isCustom, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $IncomeCategoryEntityCopyWith<$Res>  {
  factory $IncomeCategoryEntityCopyWith(IncomeCategoryEntity value, $Res Function(IncomeCategoryEntity) _then) = _$IncomeCategoryEntityCopyWithImpl;
@useResult
$Res call({
 String id, String displayLabel, String emoji, bool isCustom, bool isDeleted
});




}
/// @nodoc
class _$IncomeCategoryEntityCopyWithImpl<$Res>
    implements $IncomeCategoryEntityCopyWith<$Res> {
  _$IncomeCategoryEntityCopyWithImpl(this._self, this._then);

  final IncomeCategoryEntity _self;
  final $Res Function(IncomeCategoryEntity) _then;

/// Create a copy of IncomeCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayLabel = null,Object? emoji = null,Object? isCustom = null,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomeCategoryEntity].
extension IncomeCategoryEntityPatterns on IncomeCategoryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomeCategoryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomeCategoryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomeCategoryEntity value)  $default,){
final _that = this;
switch (_that) {
case _IncomeCategoryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomeCategoryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _IncomeCategoryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayLabel,  String emoji,  bool isCustom,  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomeCategoryEntity() when $default != null:
return $default(_that.id,_that.displayLabel,_that.emoji,_that.isCustom,_that.isDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayLabel,  String emoji,  bool isCustom,  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _IncomeCategoryEntity():
return $default(_that.id,_that.displayLabel,_that.emoji,_that.isCustom,_that.isDeleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayLabel,  String emoji,  bool isCustom,  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _IncomeCategoryEntity() when $default != null:
return $default(_that.id,_that.displayLabel,_that.emoji,_that.isCustom,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc


class _IncomeCategoryEntity implements IncomeCategoryEntity {
  const _IncomeCategoryEntity({required this.id, required this.displayLabel, required this.emoji, this.isCustom = false, this.isDeleted = false});
  

@override final  String id;
@override final  String displayLabel;
@override final  String emoji;
@override@JsonKey() final  bool isCustom;
@override@JsonKey() final  bool isDeleted;

/// Create a copy of IncomeCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomeCategoryEntityCopyWith<_IncomeCategoryEntity> get copyWith => __$IncomeCategoryEntityCopyWithImpl<_IncomeCategoryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomeCategoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.displayLabel, displayLabel) || other.displayLabel == displayLabel)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayLabel,emoji,isCustom,isDeleted);

@override
String toString() {
  return 'IncomeCategoryEntity(id: $id, displayLabel: $displayLabel, emoji: $emoji, isCustom: $isCustom, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$IncomeCategoryEntityCopyWith<$Res> implements $IncomeCategoryEntityCopyWith<$Res> {
  factory _$IncomeCategoryEntityCopyWith(_IncomeCategoryEntity value, $Res Function(_IncomeCategoryEntity) _then) = __$IncomeCategoryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayLabel, String emoji, bool isCustom, bool isDeleted
});




}
/// @nodoc
class __$IncomeCategoryEntityCopyWithImpl<$Res>
    implements _$IncomeCategoryEntityCopyWith<$Res> {
  __$IncomeCategoryEntityCopyWithImpl(this._self, this._then);

  final _IncomeCategoryEntity _self;
  final $Res Function(_IncomeCategoryEntity) _then;

/// Create a copy of IncomeCategoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayLabel = null,Object? emoji = null,Object? isCustom = null,Object? isDeleted = null,}) {
  return _then(_IncomeCategoryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayLabel: null == displayLabel ? _self.displayLabel : displayLabel // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
