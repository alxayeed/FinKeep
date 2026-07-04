import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/income_category/income_category_entity.dart';

part 'income_category_model.freezed.dart';
part 'income_category_model.g.dart';

@freezed
abstract class IncomeCategoryModel with _$IncomeCategoryModel {
  const IncomeCategoryModel._();

  const factory IncomeCategoryModel({
    required String id,
    required String displayLabel,
    required String emoji,
    @Default(false) bool isCustom,
    @Default(false) bool isDeleted,
  }) = _IncomeCategoryModel;

  factory IncomeCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeCategoryModelFromJson(json);

  factory IncomeCategoryModel.fromFirestoreMap(Map<String, dynamic> json) {
    return IncomeCategoryModel(
      id: (json['id'] ?? '').toString(),
      displayLabel: (json['displayLabel'] ?? 'Other').toString(),
      emoji: (json['emoji'] ?? '💰').toString(),
      isCustom: json['isCustom'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  factory IncomeCategoryModel.fromEntity(IncomeCategoryEntity entity) {
    return IncomeCategoryModel(
      id: entity.id,
      displayLabel: entity.displayLabel,
      emoji: entity.emoji,
      isCustom: entity.isCustom,
      isDeleted: entity.isDeleted,
    );
  }

  IncomeCategoryEntity toEntity() {
    return IncomeCategoryEntity(
      id: id,
      displayLabel: displayLabel,
      emoji: emoji,
      isCustom: isCustom,
      isDeleted: isDeleted,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return toJson();
  }
}
