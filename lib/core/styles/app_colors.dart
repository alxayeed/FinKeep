import 'package:flutter/material.dart';

import '../../features/lendings/domain/entity/lending/lending_entity.dart';
import '../enums/expense_category.dart';

class AppColors {
  static const Color primaryTeal = Color(0xFF059669); // Emerald 600 brand color
  static const Color primaryTealLight = Color(0xFF34D399); // Emerald 400
  static const Color primaryTealDark = Color(0xFF047857); // Emerald 700
  static const Color primaryTealAccent = Color(0xFF10B981); // Emerald 500

  static const Color iconColor = primaryTealDark;
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color enabledBorderColor = Color(0xFFE2E8F0);
  static const Color focusedBorderColor = primaryTeal;
  static const Color subtleBackground = Color(0xFFECFDF5); // Emerald 50
  static const Color buttonText = Colors.white;

  static const Color success = Color(0xFF059669);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Background and Card Layout Colors
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color bgDark = Color(0xFF0F172A);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);
  static const Color dividerLight = Color(0xFFF1F5F9);
  static const Color dividerDark = Color(0xFF334155);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF64748B);
  static const Color orange = Color(0xFFF97316);
  static const Color lightGrey = Color(0xFFCBD5E1);
  static const Color darkGrey = Color(0xFF334155);
  static const Color hintText = Color(0xFF94A3B8);

  static const Color lendingGiven = error;
  static const Color lendingTaken = success;

  static const Color lendingStatusDue = warning;
  static const Color lendingStatusPaid = success;
  static const Color lendingStatusDismissed = grey;
  static const Color lendingStatusPartial = orange;

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
        return lendingStatusPartial;
    }
  }
}
