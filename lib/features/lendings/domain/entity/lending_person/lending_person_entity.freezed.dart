// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lending_person_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LendingPersonEntity {
  String get id;
  String get userId;
  String get name;
  String? get contactNumber;
  String? get email;
  String? get notes;

  /// Create a copy of LendingPersonEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LendingPersonEntityCopyWith<LendingPersonEntity> get copyWith =>
      _$LendingPersonEntityCopyWithImpl<LendingPersonEntity>(
          this as LendingPersonEntity, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LendingPersonEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, name, contactNumber, email, notes);

  @override
  String toString() {
    return 'LendingPersonEntity(id: $id, userId: $userId, name: $name, contactNumber: $contactNumber, email: $email, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class $LendingPersonEntityCopyWith<$Res> {
  factory $LendingPersonEntityCopyWith(
          LendingPersonEntity value, $Res Function(LendingPersonEntity) _then) =
      _$LendingPersonEntityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? contactNumber,
      String? email,
      String? notes});
}

/// @nodoc
class _$LendingPersonEntityCopyWithImpl<$Res>
    implements $LendingPersonEntityCopyWith<$Res> {
  _$LendingPersonEntityCopyWithImpl(this._self, this._then);

  final LendingPersonEntity _self;
  final $Res Function(LendingPersonEntity) _then;

  /// Create a copy of LendingPersonEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? contactNumber = freezed,
    Object? email = freezed,
    Object? notes = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contactNumber: freezed == contactNumber
          ? _self.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LendingPersonEntity].
extension LendingPersonEntityPatterns on LendingPersonEntity {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_LendingPersonEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LendingPersonEntity() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_LendingPersonEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LendingPersonEntity():
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_LendingPersonEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LendingPersonEntity() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String userId, String name,
            String? contactNumber, String? email, String? notes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LendingPersonEntity() when $default != null:
        return $default(_that.id, _that.userId, _that.name, _that.contactNumber,
            _that.email, _that.notes);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String userId, String name,
            String? contactNumber, String? email, String? notes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LendingPersonEntity():
        return $default(_that.id, _that.userId, _that.name, _that.contactNumber,
            _that.email, _that.notes);
      case _:
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String userId, String name,
            String? contactNumber, String? email, String? notes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LendingPersonEntity() when $default != null:
        return $default(_that.id, _that.userId, _that.name, _that.contactNumber,
            _that.email, _that.notes);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LendingPersonEntity implements LendingPersonEntity {
  const _LendingPersonEntity(
      {required this.id,
      required this.userId,
      required this.name,
      this.contactNumber,
      this.email,
      this.notes});

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  final String? contactNumber;
  @override
  final String? email;
  @override
  final String? notes;

  /// Create a copy of LendingPersonEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LendingPersonEntityCopyWith<_LendingPersonEntity> get copyWith =>
      __$LendingPersonEntityCopyWithImpl<_LendingPersonEntity>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LendingPersonEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contactNumber, contactNumber) ||
                other.contactNumber == contactNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, name, contactNumber, email, notes);

  @override
  String toString() {
    return 'LendingPersonEntity(id: $id, userId: $userId, name: $name, contactNumber: $contactNumber, email: $email, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class _$LendingPersonEntityCopyWith<$Res>
    implements $LendingPersonEntityCopyWith<$Res> {
  factory _$LendingPersonEntityCopyWith(_LendingPersonEntity value,
          $Res Function(_LendingPersonEntity) _then) =
      __$LendingPersonEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      String? contactNumber,
      String? email,
      String? notes});
}

/// @nodoc
class __$LendingPersonEntityCopyWithImpl<$Res>
    implements _$LendingPersonEntityCopyWith<$Res> {
  __$LendingPersonEntityCopyWithImpl(this._self, this._then);

  final _LendingPersonEntity _self;
  final $Res Function(_LendingPersonEntity) _then;

  /// Create a copy of LendingPersonEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? contactNumber = freezed,
    Object? email = freezed,
    Object? notes = freezed,
  }) {
    return _then(_LendingPersonEntity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      contactNumber: freezed == contactNumber
          ? _self.contactNumber
          : contactNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
