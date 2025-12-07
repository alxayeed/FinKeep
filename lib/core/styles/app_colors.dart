import 'package:flutter/material.dart';

import '../../features/lendings/domain/entity/lending/lending_entity.dart';
import '../enums/expense_category.dart';

class AppColors {
  static const Color primaryTeal = Colors.teal;
  static const Color primaryTealLight = Color(0xFF4DB6AC);
  static const Color primaryTealDark = Color(0xFF00695C);
  static const Color primaryTealAccent = Color(0xFF64FFDA);

  static const Color iconColor = primaryTealDark;
  static const Color borderColor = primaryTealLight;
  static const Color enabledBorderColor = Color(0xFFB2DFDB);
  static const Color focusedBorderColor = primaryTeal;
  static const Color subtleBackground = Color(0xFFE0F2F1);
  static const Color buttonText = Colors.white;

  static const Color success = Colors.green;
  static const Color error = Colors.redAccent;
  static const Color warning = Colors.orangeAccent;

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color darkGrey = Color(0xFF616161);
  static const Color hintText = Colors.grey;

  static const Color lendingGiven = error;
  static const Color lendingTaken = success;

  static const Color lendingStatusDue = warning;
  static const Color lendingStatusPaid = success;
  static const Color lendingStatusDismissed = grey;

  static const Map<ExpenseCategory, Color> categoryColors = {
    ExpenseCategory.food: primaryTeal,
    ExpenseCategory.transport: Colors.green,
    ExpenseCategory.family: Colors.blue,
    ExpenseCategory.personal: Colors.purple,
    ExpenseCategory.lend: Colors.orange,
    ExpenseCategory.clothing: Colors.brown,
    ExpenseCategory.hangout: Colors.cyan,
    ExpenseCategory.utilities: Colors.amber,
    ExpenseCategory.other: grey,
  };

  static const Color defaultColor = black;

  static Color getColorForCategory(String category) {
    try {
      final expenseCategory = ExpenseCategoryExtension.fromString(category);
      return categoryColors[expenseCategory] ?? defaultColor;
    } catch (_) {
      return defaultColor;
    }
  }

  static Color getColorForLendingType(LendingType type) {
    switch (type) {
      case LendingType.given:
        return lendingGiven;
      case LendingType.taken:
        return lendingTaken;
    }
  }

  static Color getColorForLendingStatus(LendingStatus status) {
    switch (status) {
      case LendingStatus.due:
        return lendingStatusDue;
      case LendingStatus.paid:
        return lendingStatusPaid;
      case LendingStatus.overdue:
        return lendingStatusDismissed;
      case LendingStatus.partial:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
