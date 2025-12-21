import 'package:flutter/material.dart';

enum InvestmentStatus { active, returnsStarted, completed, loss }

extension InvestmentStatusExtension on InvestmentStatus {
  String get label {
    switch (this) {
      case InvestmentStatus.active:
        return 'Active';
      case InvestmentStatus.returnsStarted:
        return 'Returns Started';
      case InvestmentStatus.completed:
        return 'Completed';
      case InvestmentStatus.loss:
        return 'Loss';
    }
  }

  Color get color {
    switch (this) {
      case InvestmentStatus.active:
        return Colors.blue;
      case InvestmentStatus.returnsStarted:
        return Colors.orange;
      case InvestmentStatus.completed:
        return Colors.green;
      case InvestmentStatus.loss:
        return Colors.red;
    }
  }
}
