import 'package:freezed_annotation/freezed_annotation.dart';

part 'lending_person_entity.freezed.dart';

@freezed
abstract class LendingPersonEntity with _$LendingPersonEntity {
  const factory LendingPersonEntity({
    required String id,
    required String userId,
    required String name,
    String? contactNumber,
    String? email,
    String? notes,
  }) = _LendingPersonEntity;
}
