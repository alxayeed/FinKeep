import 'package:equatable/equatable.dart';

import '../entity/lending/lending_entity.dart';

class GetLendingsParams extends Equatable {
  final String userId;
  final LendingType? typeFilter;
  final DateTime? monthFilter;
  final LendingStatus? statusFilter;
  final String? personNameFilter;

  const GetLendingsParams({
    required this.userId,
    this.typeFilter,
    this.monthFilter,
    this.statusFilter,
    this.personNameFilter,
  });

  @override
  List<Object?> get props => [
        userId,
        typeFilter,
        monthFilter,
        statusFilter,
        personNameFilter,
      ];
}
