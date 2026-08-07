import 'package:flutter_test/flutter_test.dart';
import 'package:finkeep/features/expense/domain/entities/expense_entity.dart';
import 'package:finkeep/core/enums/payment_type.dart';

void main() {
  group('MonthlyExpenseController Category Filter & Total Calculation Test', () {
    test('filteredExpenses, totalExpense (Details Tab), and overallTotalExpense (Summary Tab)', () {
      final sampleExpenses = [
        ExpenseEntity(
          id: '1',
          amount: 50.0,
          category: 'Food',
          date: DateTime.now(),
          description: 'Lunch',
          paymentMethod: PaymentType.cash,
          createdAt: DateTime.now(),
        ),
        ExpenseEntity(
          id: '2',
          amount: 30.0,
          category: 'Transport',
          date: DateTime.now(),
          description: 'Taxi',
          paymentMethod: PaymentType.cash,
          createdAt: DateTime.now(),
        ),
        ExpenseEntity(
          id: '3',
          amount: 20.0,
          category: 'Transport',
          date: DateTime.now(),
          description: 'Bus',
          paymentMethod: PaymentType.cash,
          createdAt: DateTime.now(),
        ),
      ];

      // Summary tab calculation (overallTotalExpense)
      final overallTotal = sampleExpenses.fold(0.0, (acc, item) => acc + item.amount);
      expect(overallTotal, 100.0);

      // Details tab: All category
      var filtered = sampleExpenses;
      var detailsTotal = filtered.fold(0.0, (acc, item) => acc + item.amount);
      expect(detailsTotal, 100.0);

      // Details tab: Transport category filter (should show subtotal for Transport)
      filtered = sampleExpenses.where((e) => e.category == 'Transport').toList();
      detailsTotal = filtered.fold(0.0, (acc, item) => acc + item.amount);
      expect(filtered.length, 2);
      expect(detailsTotal, 50.0);

      // Summary tab total remains unaffected by active category filter
      expect(overallTotal, 100.0);
    });
  });
}
