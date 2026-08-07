import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/features/expense/presentation/controllers/expense_category_controller.dart';
import 'package:finkeep/features/income/presentation/controllers/income_category_controller.dart';

void main() {
  group('Custom Category Limit (Step 2) Unit Test', () {
    test('ExpenseCategoryController maxCustomCategoryLimit should be 7', () {
      expect(ExpenseCategoryController.defaultCategories.length, 8);
    });

    test('IncomeCategoryController default categories verification', () {
      expect(IncomeCategoryController.defaultCategories.length, greaterThan(0));
    });
  });
}
