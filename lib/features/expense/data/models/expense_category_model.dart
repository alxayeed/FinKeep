import '../../domain/entities/expense_category_entity.dart';

class ExpenseCategoryModel extends ExpenseCategoryEntity {
  const ExpenseCategoryModel({
    required super.id,
    required super.displayLabel,
    required super.emoji,
    super.isCustom = false,
    super.isDeleted = false,
  });

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: json['id'] as String,
      displayLabel: json['displayLabel'] as String,
      emoji: json['emoji'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  factory ExpenseCategoryModel.fromFirestoreMap(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: json['id'] as String,
      displayLabel: json['displayLabel'] as String,
      emoji: json['emoji'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayLabel': displayLabel,
      'emoji': emoji,
      'isCustom': isCustom,
      'isDeleted': isDeleted,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'displayLabel': displayLabel,
      'emoji': emoji,
      'isCustom': isCustom,
      'isDeleted': isDeleted,
    };
  }

  ExpenseCategoryEntity toEntity() {
    return ExpenseCategoryEntity(
      id: id,
      displayLabel: displayLabel,
      emoji: emoji,
      isCustom: isCustom,
      isDeleted: isDeleted,
    );
  }

  factory ExpenseCategoryModel.fromEntity(ExpenseCategoryEntity entity) {
    return ExpenseCategoryModel(
      id: entity.id,
      displayLabel: entity.displayLabel,
      emoji: entity.emoji,
      isCustom: entity.isCustom,
      isDeleted: entity.isDeleted,
    );
  }

  @override
  ExpenseCategoryModel copyWith({
    String? id,
    String? displayLabel,
    String? emoji,
    bool? isCustom,
    bool? isDeleted,
  }) {
    return ExpenseCategoryModel(
      id: id ?? this.id,
      displayLabel: displayLabel ?? this.displayLabel,
      emoji: emoji ?? this.emoji,
      isCustom: isCustom ?? this.isCustom,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
