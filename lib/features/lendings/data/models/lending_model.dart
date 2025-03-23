// import '../../../../core/enums/lending_type.dart';
// import '../../domain/entity/lend_entity.dart';
//
// class LendingModel extends LendingEntity {
//   final String id;
//
//   const LendingModel({
//     required this.id,
//     required super.amount,
//     required super.date,
//     required super.dueDate,
//     required super.lenderId,
//     required super.borrowerName,
//     required super.type,
//     super.note,
//   });
//
//   factory LendingModel.fromJson(Map<String, dynamic> json) {
//     return LendingModel(
//       id: json['id'],
//       amount: json['amount'],
//       date: DateTime.parse(json['date']),
//       dueDate: DateTime.parse(json['dueDate']),
//       lenderId: json['lenderId'],
//       borrowerName: json['borrowerName'],
//       type: LendingType.values.firstWhere((e) => e.toString() == json['type']),
//       note: json['note'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'amount': amount,
//       'date': date.toIso8601String(),
//       'dueDate': dueDate.toIso8601String(),
//       'lenderId': lenderId,
//       'borrowerName': borrowerName,
//       'type': type.toString(),
//       'note': note,
//     };
//   }
// }
