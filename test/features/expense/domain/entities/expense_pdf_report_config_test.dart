import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:finkeep/features/expense/domain/entities/expense_entity.dart';
import 'package:finkeep/features/expense/domain/entities/expense_pdf_report_config.dart';

void main() {
  group('ExpensePdfReportConfig & Grouping Tests', () {
    final now = DateTime(2026, 8, 28, 14, 30);
    final sameDayLater = DateTime(2026, 8, 28, 18, 00);
    final previousDay = DateTime(2026, 8, 27, 10, 00);
    final previousYear = DateTime(2025, 12, 20, 11, 00);

    final sampleExpenses = [
      ExpenseEntity(
        id: '1',
        amount: 3850.0,
        category: 'Food',
        date: now,
        description: 'Agora grocery',
        paymentMethod: PaymentType.card,
        createdAt: now,
      ),
      ExpenseEntity(
        id: '2',
        amount: 500.0,
        category: 'Food',
        date: sameDayLater,
        description: 'Evening Snacks',
        paymentMethod: PaymentType.cash,
        createdAt: sameDayLater,
      ),
      ExpenseEntity(
        id: '3',
        amount: 500.0,
        category: 'Transport',
        date: now,
        description: 'Uber ride',
        paymentMethod: PaymentType.mfs,
        createdAt: now,
      ),
      ExpenseEntity(
        id: '4',
        amount: 4500.0,
        category: 'Utilities',
        date: previousDay,
        description: 'Electricity DESCO',
        paymentMethod: PaymentType.mfs,
        createdAt: previousDay,
      ),
      ExpenseEntity(
        id: '5',
        amount: 8400.0,
        category: 'Clothing',
        date: previousYear,
        description: 'Winter clothes',
        paymentMethod: PaymentType.card,
        createdAt: previousYear,
      ),
    ];

    test('ExpensePdfReportConfig default values and props equality', () {
      final config = ExpensePdfReportConfig(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );

      expect(config.selectedCategory, 'All');
      expect(config.mode, ExpenseReportPdfMode.compact);
      expect(config.currencySymbol, '৳');
      expect(config.currencyCode, 'BDT');
      expect(config.mode.displayName, 'Compact');
      expect(ExpenseReportPdfMode.details.displayName, 'Details');

      final copy = ExpensePdfReportConfig(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );
      expect(config, equals(copy));
    });

    test('groupExpensesForCompactMode groups same date & category and sums amount', () {
      final grouped = groupExpensesForCompactMode(sampleExpenses);

      // Total items should be 4:
      // 1. 28 Aug 2026 - Food: 3850 + 500 = 4350
      // 2. 28 Aug 2026 - Transport: 500
      // 3. 27 Aug 2026 - Utilities: 4500
      // 4. 20 Dec 2025 - Clothing: 8400
      expect(grouped.length, 4);

      final foodRow28 = grouped.firstWhere(
        (r) =>
            r.date.year == 2026 &&
            r.date.month == 8 &&
            r.date.day == 28 &&
            r.category == 'Food',
      );
      expect(foodRow28.totalAmount, 4350.0);

      final transportRow28 = grouped.firstWhere(
        (r) =>
            r.date.year == 2026 &&
            r.date.month == 8 &&
            r.date.day == 28 &&
            r.category == 'Transport',
      );
      expect(transportRow28.totalAmount, 500.0);

      final utilitiesRow27 = grouped.firstWhere(
        (r) =>
            r.date.year == 2026 &&
            r.date.month == 8 &&
            r.date.day == 27 &&
            r.category == 'Utilities',
      );
      expect(utilitiesRow27.totalAmount, 4500.0);

      final clothingRow2025 = grouped.firstWhere(
        (r) =>
            r.date.year == 2025 &&
            r.date.month == 12 &&
            r.date.day == 20 &&
            r.category == 'Clothing',
      );
      expect(clothingRow2025.totalAmount, 8400.0);

      // Verify total sum equals original sum
      final originalTotal = sampleExpenses.fold(0.0, (acc, item) => acc + item.amount);
      final groupedTotal = grouped.fold(0.0, (acc, item) => acc + item.totalAmount);
      expect(groupedTotal, originalTotal);
    });

    test('groupExpensesForCompactMode returns empty list on empty input', () {
      final grouped = groupExpensesForCompactMode([]);
      expect(grouped, isEmpty);
    });
  });
}
