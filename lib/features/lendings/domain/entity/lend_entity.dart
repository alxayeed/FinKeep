import 'package:equatable/equatable.dart';

import 'lending/lending_entity.dart';

// enum LendingType {
//   given,
//   taken,
// }
//
// enum LendingStatus {
//   due,
//   paid,
//   dismissed,
// }

class LendEntity extends Equatable {
  final String id;
  final LendingType type;
  final String personName;
  final double amount;
  final String? description;
  final DateTime createdDate;
  final DateTime? dueDate;
  final LendingStatus status;
  final String userId;

  const LendEntity({
    required this.id,
    required this.type,
    required this.personName,
    required this.amount,
    this.description,
    required this.createdDate,
    this.dueDate, // Nullable
    required this.status,
    this.userId = '',
  });

  @override
  List<Object?> get props => [
        id,
        type,
        personName,
        amount,
        description,
        createdDate,
        dueDate,
        status,
        userId,
      ];

// Note: Usually Repositories convert Model -> Entity.
// This method might be more useful in the Model (fromEntity)
// or before saving (converting Entity -> Model in Repository/DataSource).
// Keeping consistent with your ExpenseEntity pattern for now.
// LendingModel toModel() {
//   return LendingModel(
//     id: id,
//     type: type,
//     personName: personName,
//     amount: amount,
//     description: description,
//     createdDate: createdDate,
//     dueDate: dueDate,
//     status: status,
//     userId: userId,
//   );
// }
//
// LendEntity copyWith({
//   String? id,
//   LendingType? type,
//   String? personName,
//   double? amount,
//   // Use Object() trick for explicit null assignment if needed, else standard null handling
//   String? description,
//   DateTime? createdDate,
//   DateTime? dueDate,
//   LendingStatus? status,
//   String? userId,
// }) {
//   return LendEntity(
//     id: id ?? this.id,
//     type: type ?? this.type,
//     personName: personName ?? this.personName,
//     amount: amount ?? this.amount,
//     description: description ?? this.description,
//     createdDate: createdDate ?? this.createdDate,
//     dueDate: dueDate ?? this.dueDate,
//     status: status ?? this.status,
//     userId: userId ?? this.userId,
//   );
//   // For explicit null assignment for nullable fields (more complex):
//   // Use a helper like `ValueGetter<T?>` or a special sentinel object.
//   // Example:
//   // description: (description is ValueGetter<String?>) ? description() : this.description,
//   // dueDate: (dueDate is ValueGetter<DateTime?>) ? dueDate() : this.dueDate,
//   // Where you'd call copyWith(description: () => null) to explicitly set null.
//   // Sticking to simpler version above for now.
// }
}
