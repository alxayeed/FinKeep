import 'package:equatable/equatable.dart';

class ExpenseCategoryEntity extends Equatable {
  final String id;
  final String displayLabel;
  final String emoji;
  final bool isCustom;
  final bool isDeleted;

  const ExpenseCategoryEntity({
    required this.id,
    required this.displayLabel,
    required this.emoji,
    this.isCustom = false,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [id, displayLabel, emoji, isCustom, isDeleted];

  ExpenseCategoryEntity copyWith({
    String? id,
    String? displayLabel,
    String? emoji,
    bool? isCustom,
    bool? isDeleted,
  }) {
    return ExpenseCategoryEntity(
      id: id ?? this.id,
      displayLabel: displayLabel ?? this.displayLabel,
      emoji: emoji ?? this.emoji,
      isCustom: isCustom ?? this.isCustom,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
