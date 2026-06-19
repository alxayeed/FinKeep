import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entity/lending_person/lending_person_entity.dart';

part 'lending_person_model.freezed.dart';
part 'lending_person_model.g.dart';

@freezed
abstract class LendingPersonModel with _$LendingPersonModel {
  const LendingPersonModel._();

  const factory LendingPersonModel({
    required String id,
    required String name,
    String? contactNumber,
    String? email,
    String? notes,
  }) = _LendingPersonModel;

  factory LendingPersonModel.fromJson(Map<String, dynamic> json) =>
      _$LendingPersonModelFromJson(json);

  factory LendingPersonModel.fromEntity(LendingPersonEntity entity) {
    return LendingPersonModel(
      id: entity.id,
      name: entity.name,
      contactNumber: entity.contactNumber,
      email: entity.email,
      notes: entity.notes,
    );
  }

  LendingPersonEntity toEntity() {
    return LendingPersonEntity(
      id: id,
      name: name,
      contactNumber: contactNumber,
      email: email,
      notes: notes,
    );
  }
}
