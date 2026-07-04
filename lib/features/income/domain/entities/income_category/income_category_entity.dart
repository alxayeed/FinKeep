import 'package:freezed_annotation/freezed_annotation.dart';

part 'income_category_entity.freezed.dart';

@freezed
abstract class IncomeCategoryEntity with _$IncomeCategoryEntity {
  const factory IncomeCategoryEntity({
    required String id,
    required String displayLabel,
    required String emoji,
    @Default(false) bool isCustom,
    @Default(false) bool isDeleted,
  }) = _IncomeCategoryEntity;
}
