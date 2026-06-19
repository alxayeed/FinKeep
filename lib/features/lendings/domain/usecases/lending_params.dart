import 'package:equatable/equatable.dart';

import '../entity/lending/lending_entity.dart';

class GetLendingsParams extends Equatable {
  final LendingType? typeFilter;
  final DateTime? monthFilter;
  final LendingStatus? statusFilter;
  final String? personNameFilter;

  const GetLendingsParams({
    this.typeFilter,
    this.monthFilter,
    this.statusFilter,
    this.personNameFilter,
  });

  @override
  List<Object?> get props => [
        typeFilter,
        monthFilter,
        statusFilter,
        personNameFilter,
      ];
}
