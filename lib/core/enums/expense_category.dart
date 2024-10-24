enum ExpenseCategory {
  food,
  transport,
  family,
  personal,
  lend,
  clothing,
  hangout,
  utilities,
  other,
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.family:
        return 'Family';
      case ExpenseCategory.personal:
        return 'Personal';
      case ExpenseCategory.lend:
        return 'Lend';
      case ExpenseCategory.hangout:
        return 'Hangout';
      case ExpenseCategory.clothing:
        return 'Clothing';
      case ExpenseCategory.utilities:
        return 'Utilities';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}
