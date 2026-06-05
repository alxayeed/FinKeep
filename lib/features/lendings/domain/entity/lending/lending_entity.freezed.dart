// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lending_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LendingEntity {

 String get id; LendingType get type; String get personId; LendingPersonEntity get person; double get amount; double get repaidAmount; String? get description; DateTime get createdDate; DateTime? get dueDate; LendingStatus get status; String get userId; List<RepaymentEntity>? get repayments;
/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LendingEntityCopyWith<LendingEntity> get copyWith => _$LendingEntityCopyWithImpl<LendingEntity>(this as LendingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.person, person) || other.person == person)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.repaidAmount, repaidAmount) || other.repaidAmount == repaidAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.repayments, repayments));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,personId,person,amount,repaidAmount,description,createdDate,dueDate,status,userId,const DeepCollectionEquality().hash(repayments));

@override
String toString() {
  return 'LendingEntity(id: $id, type: $type, personId: $personId, person: $person, amount: $amount, repaidAmount: $repaidAmount, description: $description, createdDate: $createdDate, dueDate: $dueDate, status: $status, userId: $userId, repayments: $repayments)';
}


}

/// @nodoc
abstract mixin class $LendingEntityCopyWith<$Res>  {
  factory $LendingEntityCopyWith(LendingEntity value, $Res Function(LendingEntity) _then) = _$LendingEntityCopyWithImpl;
@useResult
$Res call({
 String id, LendingType type, String personId, LendingPersonEntity person, double amount, double repaidAmount, String? description, DateTime createdDate, DateTime? dueDate, LendingStatus status, String userId, List<RepaymentEntity>? repayments
});


$LendingPersonEntityCopyWith<$Res> get person;

}
/// @nodoc
class _$LendingEntityCopyWithImpl<$Res>
    implements $LendingEntityCopyWith<$Res> {
  _$LendingEntityCopyWithImpl(this._self, this._then);

  final LendingEntity _self;
  final $Res Function(LendingEntity) _then;

/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? personId = null,Object? person = null,Object? amount = null,Object? repaidAmount = null,Object? description = freezed,Object? createdDate = null,Object? dueDate = freezed,Object? status = null,Object? userId = null,Object? repayments = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LendingType,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as LendingPersonEntity,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,repaidAmount: null == repaidAmount ? _self.repaidAmount : repaidAmount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LendingStatus,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,repayments: freezed == repayments ? _self.repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<RepaymentEntity>?,
  ));
}
/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LendingPersonEntityCopyWith<$Res> get person {
  
  return $LendingPersonEntityCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// Adds pattern-matching-related methods to [LendingEntity].
extension LendingEntityPatterns on LendingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LendingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LendingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LendingEntity value)  $default,){
final _that = this;
switch (_that) {
case _LendingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LendingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LendingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LendingType type,  String personId,  LendingPersonEntity person,  double amount,  double repaidAmount,  String? description,  DateTime createdDate,  DateTime? dueDate,  LendingStatus status,  String userId,  List<RepaymentEntity>? repayments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LendingEntity() when $default != null:
return $default(_that.id,_that.type,_that.personId,_that.person,_that.amount,_that.repaidAmount,_that.description,_that.createdDate,_that.dueDate,_that.status,_that.userId,_that.repayments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LendingType type,  String personId,  LendingPersonEntity person,  double amount,  double repaidAmount,  String? description,  DateTime createdDate,  DateTime? dueDate,  LendingStatus status,  String userId,  List<RepaymentEntity>? repayments)  $default,) {final _that = this;
switch (_that) {
case _LendingEntity():
return $default(_that.id,_that.type,_that.personId,_that.person,_that.amount,_that.repaidAmount,_that.description,_that.createdDate,_that.dueDate,_that.status,_that.userId,_that.repayments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LendingType type,  String personId,  LendingPersonEntity person,  double amount,  double repaidAmount,  String? description,  DateTime createdDate,  DateTime? dueDate,  LendingStatus status,  String userId,  List<RepaymentEntity>? repayments)?  $default,) {final _that = this;
switch (_that) {
case _LendingEntity() when $default != null:
return $default(_that.id,_that.type,_that.personId,_that.person,_that.amount,_that.repaidAmount,_that.description,_that.createdDate,_that.dueDate,_that.status,_that.userId,_that.repayments);case _:
  return null;

}
}

}

/// @nodoc


class _LendingEntity implements LendingEntity {
  const _LendingEntity({required this.id, required this.type, required this.personId, required this.person, required this.amount, required this.repaidAmount, this.description, required this.createdDate, this.dueDate, required this.status, required this.userId, final  List<RepaymentEntity>? repayments}): _repayments = repayments;
  

@override final  String id;
@override final  LendingType type;
@override final  String personId;
@override final  LendingPersonEntity person;
@override final  double amount;
@override final  double repaidAmount;
@override final  String? description;
@override final  DateTime createdDate;
@override final  DateTime? dueDate;
@override final  LendingStatus status;
@override final  String userId;
 final  List<RepaymentEntity>? _repayments;
@override List<RepaymentEntity>? get repayments {
  final value = _repayments;
  if (value == null) return null;
  if (_repayments is EqualUnmodifiableListView) return _repayments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LendingEntityCopyWith<_LendingEntity> get copyWith => __$LendingEntityCopyWithImpl<_LendingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LendingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.person, person) || other.person == person)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.repaidAmount, repaidAmount) || other.repaidAmount == repaidAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._repayments, _repayments));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,personId,person,amount,repaidAmount,description,createdDate,dueDate,status,userId,const DeepCollectionEquality().hash(_repayments));

@override
String toString() {
  return 'LendingEntity(id: $id, type: $type, personId: $personId, person: $person, amount: $amount, repaidAmount: $repaidAmount, description: $description, createdDate: $createdDate, dueDate: $dueDate, status: $status, userId: $userId, repayments: $repayments)';
}


}

/// @nodoc
abstract mixin class _$LendingEntityCopyWith<$Res> implements $LendingEntityCopyWith<$Res> {
  factory _$LendingEntityCopyWith(_LendingEntity value, $Res Function(_LendingEntity) _then) = __$LendingEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, LendingType type, String personId, LendingPersonEntity person, double amount, double repaidAmount, String? description, DateTime createdDate, DateTime? dueDate, LendingStatus status, String userId, List<RepaymentEntity>? repayments
});


@override $LendingPersonEntityCopyWith<$Res> get person;

}
/// @nodoc
class __$LendingEntityCopyWithImpl<$Res>
    implements _$LendingEntityCopyWith<$Res> {
  __$LendingEntityCopyWithImpl(this._self, this._then);

  final _LendingEntity _self;
  final $Res Function(_LendingEntity) _then;

/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? personId = null,Object? person = null,Object? amount = null,Object? repaidAmount = null,Object? description = freezed,Object? createdDate = null,Object? dueDate = freezed,Object? status = null,Object? userId = null,Object? repayments = freezed,}) {
  return _then(_LendingEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LendingType,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as LendingPersonEntity,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,repaidAmount: null == repaidAmount ? _self.repaidAmount : repaidAmount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LendingStatus,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,repayments: freezed == repayments ? _self._repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<RepaymentEntity>?,
  ));
}

/// Create a copy of LendingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LendingPersonEntityCopyWith<$Res> get person {
  
  return $LendingPersonEntityCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}

// dart format on
