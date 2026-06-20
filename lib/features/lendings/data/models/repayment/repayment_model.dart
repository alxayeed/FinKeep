import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:finkeep/core/utils/date_parser.dart';

import '../../../domain/entity/repayment/repayment_entity.dart';

part 'repayment_model.freezed.dart';
part 'repayment_model.g.dart';

@freezed
abstract class RepaymentModel with _$RepaymentModel {
  const RepaymentModel._();

  const factory RepaymentModel({
    required String id,
    required String lendingId,
    required double amount,
    @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate)
    required DateTime paidDate,
    String? notes,
  }) = _RepaymentModel;

  /// Plain Dart deserialization — used by Hive (via json_serializable).
  factory RepaymentModel.fromJson(Map<String, dynamic> json) =>
      _$RepaymentModelFromJson(json);

  /// Firestore-specific deserialization — reads Firestore Timestamps.
  factory RepaymentModel.fromFirestoreMap(Map<String, dynamic> json) {
    return RepaymentModel(
      id: json['id'] as String,
      lendingId: json['lendingId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paidDate: DateParser.parse(json['paidDate']),
      notes: json['notes'] as String?,
    );
  }

  /// Create Model from Domain Entity.
  factory RepaymentModel.fromEntity(RepaymentEntity entity) {
    return RepaymentModel(
      id: entity.id,
      lendingId: entity.lendingId,
      amount: entity.amount,
      paidDate: entity.paidDate,
      notes: entity.notes,
    );
  }

  /// Convert Model to Domain Entity.
  RepaymentEntity toEntity() {
    return RepaymentEntity(
      id: id,
      lendingId: lendingId,
      amount: amount,
      paidDate: paidDate,
      notes: notes,
    );
  }

  /// Firestore-specific serialization — stores dates as Timestamps.
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': id,
      'lendingId': lendingId,
      'amount': amount,
      'paidDate': Timestamp.fromDate(paidDate),
      'notes': notes,
    };
  }
}

// ---------------------------------------------------------------------------
// @JsonKey converter helpers — plain Dart types (Hive-safe).
// ---------------------------------------------------------------------------

/// Reads a DateTime from Hive (DateTime) or legacy formats (Timestamp, String).
DateTime _fromJsonDate(dynamic value) {
  return DateParser.parse(value);
}

/// Writes a plain DateTime — safe for Hive.
DateTime _toJsonDate(DateTime value) => value;
