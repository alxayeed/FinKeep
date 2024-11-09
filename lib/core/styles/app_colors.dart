import 'package:flutter/material.dart';
import '../enums/expense_category.dart';

class AppColors {
  static const Map<ExpenseCategory, Color> categoryColors = {
    ExpenseCategory.food: Colors.teal,
    ExpenseCategory.transport: Colors.green,
    ExpenseCategory.family: Colors.blue,
    ExpenseCategory.personal: Colors.purple,
    ExpenseCategory.lend: Colors.orange,
    ExpenseCategory.clothing: Colors.brown,
    ExpenseCategory.hangout: Colors.cyan,
    ExpenseCategory.utilities: Colors.amber,
    ExpenseCategory.other: Colors.grey,
  };

  static const Color defaultColor = Colors.black;

  static Color getColorForCategory(String category) {
    final expenseCategory = ExpenseCategoryExtension.fromString(category);
    print(expenseCategory);
    print(categoryColors[expenseCategory]);
    return categoryColors[expenseCategory] ?? defaultColor;
  }
}
