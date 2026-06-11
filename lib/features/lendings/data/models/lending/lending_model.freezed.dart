// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lending_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LendingModel {

 String get id; LendingType get type; String get personId;@JsonKey(includeToJson: false) LendingPersonModel get person; double get amount; double get repaidAmount; String? get description;@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime get createdDate;@JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate) DateTime? get dueDate; LendingStatus get status; String get userId;@JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod) PaymentType get paymentMethod; List<RepaymentModel>? get repayments;
/// Create a copy of LendingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LendingModelCopyWith<LendingModel> get copyWith => _$LendingModelCopyWithImpl<LendingModel>(this as LendingModel, _$identity);

  /// Serializes this LendingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LendingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.person, person) || other.person == person)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.repaidAmount, repaidAmount) || other.repaidAmount == repaidAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&const DeepCollectionEquality().equals(other.repayments, repayments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,personId,person,amount,repaidAmount,description,createdDate,dueDate,status,userId,paymentMethod,const DeepCollectionEquality().hash(repayments));

@override
String toString() {
  return 'LendingModel(id: $id, type: $type, personId: $personId, person: $person, amount: $amount, repaidAmount: $repaidAmount, description: $description, createdDate: $createdDate, dueDate: $dueDate, status: $status, userId: $userId, paymentMethod: $paymentMethod, repayments: $repayments)';
}


}

/// @nodoc
abstract mixin class $LendingModelCopyWith<$Res>  {
  factory $LendingModelCopyWith(LendingModel value, $Res Function(LendingModel) _then) = _$LendingModelCopyWithImpl;
@useResult
$Res call({
 String id, LendingType type, String personId,@JsonKey(includeToJson: false) LendingPersonModel person, double amount, double repaidAmount, String? description,@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime createdDate,@JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate) DateTime? dueDate, LendingStatus status, String userId,@JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod) PaymentType paymentMethod, List<RepaymentModel>? repayments
});


$LendingPersonModelCopyWith<$Res> get person;

}
/// @nodoc
class _$LendingModelCopyWithImpl<$Res>
    implements $LendingModelCopyWith<$Res> {
  _$LendingModelCopyWithImpl(this._self, this._then);

  final LendingModel _self;
  final $Res Function(LendingModel) _then;

/// Create a copy of LendingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? personId = null,Object? person = null,Object? amount = null,Object? repaidAmount = null,Object? description = freezed,Object? createdDate = null,Object? dueDate = freezed,Object? status = null,Object? userId = null,Object? paymentMethod = null,Object? repayments = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LendingType,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as LendingPersonModel,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,repaidAmount: null == repaidAmount ? _self.repaidAmount : repaidAmount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LendingStatus,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentType,repayments: freezed == repayments ? _self.repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<RepaymentModel>?,
  ));
}
/// Create a copy of LendingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LendingPersonModelCopyWith<$Res> get person {
  
  return $LendingPersonModelCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}


/// Adds pattern-matching-related methods to [LendingModel].
extension LendingModelPatterns on LendingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LendingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LendingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LendingModel value)  $default,){
final _that = this;
switch (_that) {
case _LendingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LendingModel value)?  $default,){
final _that = this;
switch (_that) {
case _LendingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LendingType type,  String personId, @JsonKey(includeToJson: false)  LendingPersonModel person,  double amount,  double repaidAmount,  String? description, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime createdDate, @JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate)  DateTime? dueDate,  LendingStatus status,  String userId, @JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod)  PaymentType paymentMethod,  List<RepaymentModel>? repayments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LendingModel() when $default != null:
return $default(_that.id,_that.type,_that.personId,_that.person,_that.amount,_that.repaidAmount,_that.description,_that.createdDate,_that.dueDate,_that.status,_that.userId,_that.paymentMethod,_that.repayments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LendingType type,  String personId, @JsonKey(includeToJson: false)  LendingPersonModel person,  double amount,  double repaidAmount,  String? description, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime createdDate, @JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate)  DateTime? dueDate,  LendingStatus status,  String userId, @JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod)  PaymentType paymentMethod,  List<RepaymentModel>? repayments)  $default,) {final _that = this;
switch (_that) {
case _LendingModel():
return $default(_that.id,_that.type,_that.personId,_that.person,_that.amount,_that.repaidAmount,_that.description,_that.createdDate,_that.dueDate,_that.status,_that.userId,_that.paymentMethod,_that.repayments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LendingType type,  String personId, @JsonKey(includeToJson: false)  LendingPersonModel person,  double amount,  double repaidAmount,  String? description, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)  DateTime createdDate, @JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate)  DateTime? dueDate,  LendingStatus status,  String userId, @JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod)  PaymentType paymentMethod,  List<RepaymentModel>? repayments)?  $default,) {final _that = this;
switch (_that) {
case _LendingModel() when $default != null:
return $default(_that.id,_that.type,_that.personId,_that.person,_that.amount,_that.repaidAmount,_that.description,_that.createdDate,_that.dueDate,_that.status,_that.userId,_that.paymentMethod,_that.repayments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LendingModel extends LendingModel {
  const _LendingModel({required this.id, required this.type, required this.personId, @JsonKey(includeToJson: false) required this.person, required this.amount, this.repaidAmount = 0.0, this.description, @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) required this.createdDate, @JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate) this.dueDate, required this.status, required this.userId, @JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod) this.paymentMethod = PaymentType.cash, final  List<RepaymentModel>? repayments}): _repayments = repayments,super._();
  factory _LendingModel.fromJson(Map<String, dynamic> json) => _$LendingModelFromJson(json);

@override final  String id;
@override final  LendingType type;
@override final  String personId;
@override@JsonKey(includeToJson: false) final  LendingPersonModel person;
@override final  double amount;
@override@JsonKey() final  double repaidAmount;
@override final  String? description;
@override@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) final  DateTime createdDate;
@override@JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate) final  DateTime? dueDate;
@override final  LendingStatus status;
@override final  String userId;
@override@JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod) final  PaymentType paymentMethod;
 final  List<RepaymentModel>? _repayments;
@override List<RepaymentModel>? get repayments {
  final value = _repayments;
  if (value == null) return null;
  if (_repayments is EqualUnmodifiableListView) return _repayments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LendingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LendingModelCopyWith<_LendingModel> get copyWith => __$LendingModelCopyWithImpl<_LendingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LendingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LendingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.personId, personId) || other.personId == personId)&&(identical(other.person, person) || other.person == person)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.repaidAmount, repaidAmount) || other.repaidAmount == repaidAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdDate, createdDate) || other.createdDate == createdDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&const DeepCollectionEquality().equals(other._repayments, _repayments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,personId,person,amount,repaidAmount,description,createdDate,dueDate,status,userId,paymentMethod,const DeepCollectionEquality().hash(_repayments));

@override
String toString() {
  return 'LendingModel(id: $id, type: $type, personId: $personId, person: $person, amount: $amount, repaidAmount: $repaidAmount, description: $description, createdDate: $createdDate, dueDate: $dueDate, status: $status, userId: $userId, paymentMethod: $paymentMethod, repayments: $repayments)';
}


}

/// @nodoc
abstract mixin class _$LendingModelCopyWith<$Res> implements $LendingModelCopyWith<$Res> {
  factory _$LendingModelCopyWith(_LendingModel value, $Res Function(_LendingModel) _then) = __$LendingModelCopyWithImpl;
@override @useResult
$Res call({
 String id, LendingType type, String personId,@JsonKey(includeToJson: false) LendingPersonModel person, double amount, double repaidAmount, String? description,@JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime createdDate,@JsonKey(fromJson: _fromJsonNullableDate, toJson: _toJsonNullableDate) DateTime? dueDate, LendingStatus status, String userId,@JsonKey(fromJson: _fromJsonPaymentMethod, toJson: _toJsonPaymentMethod) PaymentType paymentMethod, List<RepaymentModel>? repayments
});


@override $LendingPersonModelCopyWith<$Res> get person;

}
/// @nodoc
class __$LendingModelCopyWithImpl<$Res>
    implements _$LendingModelCopyWith<$Res> {
  __$LendingModelCopyWithImpl(this._self, this._then);

  final _LendingModel _self;
  final $Res Function(_LendingModel) _then;

/// Create a copy of LendingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? personId = null,Object? person = null,Object? amount = null,Object? repaidAmount = null,Object? description = freezed,Object? createdDate = null,Object? dueDate = freezed,Object? status = null,Object? userId = null,Object? paymentMethod = null,Object? repayments = freezed,}) {
  return _then(_LendingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LendingType,personId: null == personId ? _self.personId : personId // ignore: cast_nullable_to_non_nullable
as String,person: null == person ? _self.person : person // ignore: cast_nullable_to_non_nullable
as LendingPersonModel,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,repaidAmount: null == repaidAmount ? _self.repaidAmount : repaidAmount // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdDate: null == createdDate ? _self.createdDate : createdDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LendingStatus,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentType,repayments: freezed == repayments ? _self._repayments : repayments // ignore: cast_nullable_to_non_nullable
as List<RepaymentModel>?,
  ));
}

/// Create a copy of LendingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LendingPersonModelCopyWith<$Res> get person {
  
  return $LendingPersonModelCopyWith<$Res>(_self.person, (value) {
    return _then(_self.copyWith(person: value));
  });
}
}

// dart format on
